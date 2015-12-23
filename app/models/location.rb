require 'gsl'

class Location < ActiveRecord::Base
  INTERPOLATION_WINDOW_SECONDS = 8 

  belongs_to :trackable, polymorphic: true
  reverse_geocoded_by :latitude, :longitude

  validates :latitude, :longitude, presence: true
  validates_presence_of :trackable

  scope :with_timestamp, -> { where.not(timestamp: nil) }
  scope :without_timestamp, -> { where(timestamp: nil) }

  def geo_array 
    [latitude, longitude]
  end

  def self.during(start_at, end_at)
    where( during_arel(start_at, end_at) )
  end

  def self.interpolate_at(time)
    locations = during(time.ago(INTERPOLATION_WINDOW_SECONDS), 
                       time.since(INTERPOLATION_WINDOW_SECONDS))
    first_static = locations.without_timestamp.order(timestamp: :asc).first
    timed_locations = locations.with_timestamp.order(timestamp: :asc)
    return first_static.geo_array if first_static
    return nil if timed_locations.empty? ||
                  time < timed_locations.first.timestamp || 
                  time > timed_locations.last.timestamp
    return timed_locations.first.try(:geo_array) if timed_locations.length < 3
    cubic_interpolation(timed_locations, time)
  end

  protected

  def self.spline(values, timestamps)
    timestamps_v = GSL::Vector.alloc(timestamps)
    values_v = GSL::Vector.alloc(values)
    spline = GSL::Spline.alloc('cspline', values.length)
    spline.init(timestamps_v, values_v)
    spline
  end

  def self.lat_spline(locations)
    timestamps = locations.map { |loc| (loc.timestamp.to_f*1000).to_i }
    lats = locations.map(&:latitude)
    spline(lats, timestamps)
  end

  def self.long_spline(locations)
    timestamps = locations.map { |loc| (loc.timestamp.to_f*1000).to_i }
    longs = locations.map(&:longitude)
    spline(longs, timestamps)
  end

  def self.cubic_interpolation(locations, time)
    time_ms = (time.to_f*1000).to_i
    [lat_spline(locations).eval(time_ms), long_spline(locations).eval(time_ms)]
  end

  def self.during_arel(start_at, end_at)
    locs = arel_table
    locs[:timestamp].eq(nil).or( 
              locs[:timestamp].lteq(end_at).and(locs[:timestamp].gteq(start_at)) 
            )
  end

  def to_s
    "Location(#{id}) { latitude: #{latitude}, longitude: #{longitude}, timestamp: #{timestamp} }"
  end

end
