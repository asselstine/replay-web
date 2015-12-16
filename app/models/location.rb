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

  def self.cubic_interpolation(locations, time)
    timestamps = GSL::Vector.alloc(locations.map { |loc| (loc.timestamp.to_f*1000).to_i })
    lats = GSL::Vector.alloc(locations.map(&:latitude))
    longs = GSL::Vector.alloc(locations.map(&:longitude))
    lat_spline = GSL::Spline.alloc('cspline', lats.length)
    lat_spline.init(timestamps, lats)
    long_spline = GSL::Spline.alloc('cspline', longs.length)
    long_spline.init(timestamps, longs)
    time_ms = (time.to_f*1000).to_i
    [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
  end

  def self.during_arel(start_at, end_at)
    locs = arel_table
    locs[:timestamp].eq(nil).or( 
              locs[:timestamp].lteq(end_at).and(locs[:timestamp].gteq(start_at)) 
            )
  end

end
