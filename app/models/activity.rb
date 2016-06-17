require 'gsl'

class Activity < ActiveRecord::Base
  belongs_to :user
  has_many :edits
  has_many :drafts, inverse_of: :activity
  has_many :draft_photos
  before_validation :clear_blank_latitudes_and_longitudes
  before_validation :default_timestamps_to_now

  validate :time_series_lengths_match

  before_save :set_start_at_and_end_at

  def to_s
    <<-STRING
      Activity(#{id}) {
                    user: #{user.id},
                    strava_activity_id: #{strava_activity_id},
                    strava_name: #{strava_name},
                    strava_start_at: #{strava_start_at}
                  }
    STRING
  end

  def start_at
    super || timestamps.first
  end

  def end_at
    super || timestamps.last
  end

  def default_timestamps_to_now
    if timestamps.empty? && latitudes.length == 1
      self.timestamps = [DateTime.now.utc]
    end
  end

  def clear_blank_latitudes_and_longitudes
    latitudes.reject!(&:blank?)
    longitudes.reject!(&:blank?)
  end

  def coords_at(time)
    return unless valid_time?(time)
    if can_interpolate?
      time_ms = self.class.to_time_ms(time)
      [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
    else
      last_coords_at(time)
    end
  end

  def can_interpolate?
    timestamps.length >= 3
  end

  def valid_time?(time)
    time >= timestamps.first &&
      time <= timestamps.last
  end

  def cspline(values)
    self.class.cspline(spline_timestamps, values)
  end

  def self.to_time_ms(datetime)
    (datetime.to_f * 1000).to_i
  end

  def self.cspline(timestamps, values)
    timestamps_v = GSL::Vector.alloc(timestamps)
    values_v = GSL::Vector.alloc(values)
    spline = GSL::Spline.alloc('cspline', values.length)
    spline.init(timestamps_v, values_v)
    spline
  end

  scope :during, (lambda do |at|
    where('activities.start_at <= ?', at)
      .where('activities.end_at >= ?', at)
  end)

  def colour
    srand(id)
    (rand * 16_777_216).floor.to_s(16).rjust(6, '0')
  end

  def cspline_latlngs
    return [] if timestamps.empty?
    now = timestamps.first
    result = []
    while now < timestamps.last
      now += 0.25.seconds
      result << coords_at(now)
    end
    result
  end

  protected

  def last_coords_at(time)
    last_index = -1
    timestamps.each_with_index do |timestamp, i|
      break if timestamp > time
      last_index = i
    end
    [latitudes[last_index], longitudes[last_index]] if last_index > -1
  end

  def time_series_lengths_match
    if latitudes.length != timestamps.length
      errors.add(:latitudes, 'has different length than timestamps')
    end
    if longitudes.length != timestamps.length
      errors.add(:longitudes, 'has different length than timestamps')
    end
  end

  def lat_spline
    @lat_spline ||= cspline(latitudes)
  end

  def long_spline
    @lng_spline ||= cspline(longitudes)
  end

  def spline_timestamps
    @spline_timestamps ||= timestamps.map do |timestamp|
      (timestamp.to_f * 1000).to_i
    end
  end

  def set_start_at_and_end_at
    return unless new_record? || timestamps_changed?
    self.start_at = timestamps.first
    self.end_at = timestamps.last
  end
end
