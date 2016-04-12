require 'gsl'

class TimeSeriesData < ActiveRecord::Base
  before_validation :clear_blank_latitudes_and_longitudes
  before_validation :default_timestamps_to_now

  belongs_to :trackable

  validate :time_series_lengths_match

  def start_at
    timestamps.first
  end

  def end_at
    timestamps.last
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
    if can_interpolate?(time)
      time_ms = self.class.to_time_ms(time)
      [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
    else
      last_coords_at(time)
    end
  end

  def last_coords_at(time)
    last_index = -1
    timestamps.each_with_index do |timestamp, i|
      break if timestamp > time
      last_index = i
    end
    [latitudes[last_index], longitudes[last_index]] if last_index > -1
  end

  def self.to_time_ms(datetime)
    (datetime.to_f * 1000).to_i
  end

  def self.spline(timestamps, values)
    timestamps_v = GSL::Vector.alloc(timestamps)
    values_v = GSL::Vector.alloc(values)
    spline = GSL::Spline.alloc('cspline', values.length)
    spline.init(timestamps_v, values_v)
    spline
  end

  protected

  def time_series_lengths_match
    if latitudes.length != timestamps.length
      errors.add(:latitudes, 'has different length than timestamps')
    end
    if longitudes.length != timestamps.length
      errors.add(:longitudes, 'has different length than timestamps')
    end
  end

  def can_interpolate?(time)
    timestamps.length >= 3 &&
      time >= timestamps.first &&
      time <= timestamps.last
  end

  def lat_spline
    self.class.spline(spline_timestamps, latitudes)
  end

  def long_spline
    self.class.spline(spline_timestamps, longitudes)
  end

  def spline_timestamps
    @spline_timestamps ||= timestamps.map do |timestamp|
      (timestamp.to_f * 1000).to_i
    end
  end
end
