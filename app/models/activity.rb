require 'gsl'

# rubocop:disable Metrics/ClassLength
class Activity < ActiveRecord::Base
  include ColourFromId

  belongs_to :user
  has_many :drafts, inverse_of: :activity, dependent: :destroy
  has_many :draft_photos
  has_many :segment_efforts, dependent: :destroy
  before_validation :clear_blank_latitudes_and_longitudes
  before_validation :default_timestamps_to_now

  after_validation :set_start_at_and_end_at
  validate :time_series_lengths_match
  validates :strava_start_at,
            :timestamps,
            presence: true

  scope :at, (lambda do |at|
    where('activities.start_at <= ?', at)
      .where('activities.end_at >= ?', at)
  end)

  scope :during, (lambda do |start_at, end_at|
    query = <<-SQL
      (activities.start_at, activities.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order(start_at: :asc)
  end)

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

  def default_timestamps_to_now
    if timestamps.empty? && latitudes.length == 1
      self.start_at = Time.zone.now
      self.timestamps = [0]
    end
  end

  def clear_blank_latitudes_and_longitudes
    latitudes.reject!(&:blank?)
    longitudes.reject!(&:blank?)
  end

  def timeseries_index_at(time)
    timeseries_index_at_s(time.to_f - start_at.to_f)
  end

  def timeseries_index_at_s(seconds)
    timestamps.bsearch_index do |timestamp|
      timestamp >= seconds
    end
  end

  def coords_at(time)
    return unless valid_time?(time)
    if can_interpolate?
      time_ms = relative_time_s(time)
      [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
    else
      last_coords_at(time)
    end
  end

  def can_interpolate?
    timestamps.length >= 3
  end

  def valid_time?(time)
    relative_time_s(time) >= timestamps.first &&
      relative_time_s(time) <= timestamps.last
  end

  def cspline(values)
    self.class.cspline(spline_timestamps, values)
  end

  def relative_time_s(datetime)
    datetime.to_f - start_at.to_f
  end

  def self.cspline(timestamps, values)
    timestamps_v = GSL::Vector.alloc(timestamps)
    values_v = GSL::Vector.alloc(values)
    spline = GSL::Spline.alloc('cspline', values.length)
    spline.init(timestamps_v, values_v)
    spline
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

  def valid_index?(index)
    return false unless index
    index >= 0 && index < (timestamps&.length || 0)
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
    return unless longitudes.length != timestamps.length
    errors.add(:longitudes, 'has different length than timestamps')
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
    return unless new_record? || strava_start_at_changed? || timestamps_changed?
    self.start_at ||= strava_start_at.since(timestamps.first)
    self.end_at ||= strava_start_at.since(timestamps.last)
  end
end
