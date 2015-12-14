class Location < ActiveRecord::Base
  BALLPARK_MINIMUM_DISTANCE = Rails.env.test? ? 5000 : 100.0 / 1000.0
  INTERPOLATION_WINDOW_SECONDS=5

  validates :latitude, :longitude, presence: true
  belongs_to :trackable, polymorphic: true
  reverse_geocoded_by :latitude, :longitude

  def geo_array 
    [latitude, longitude]
  end

  def self.ballpark(location)
    near([location.latitude, location.longitude], BALLPARK_MINIMUM_DISTANCE, units: :km)
  end

  def self.during(start_at, end_at)
    where( during_arel(start_at, end_at) )
  end

  def self.ballpark_during(location, start_at, end_at)
    ballpark(location).where(during_arel(start_at, end_at))
  end

  def self.interpolate_at(time)
    locations = during(time.ago(INTERPOLATION_WINDOW_SECONDS), 
                       time.since(INTERPOLATION_WINDOW_SECONDS))
    first_static = locations
      .select { |loc| loc.timestamp.nil? }
      .sort { |a,b| a.created_at <=> b.created_at }
      .first
    timed_locations = locations
      .select { |loc| loc.timestamp.present? }
      .sort { |a,b| a.timestamp <=> b.timestamp }
    return first_static.geo_array if first_static
    return timed_locations.first.try(:geo_array) if timed_locations.length < 3
    return timed_locations.first.try(:geo_array) if time < timed_locations.first.timestamp
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
