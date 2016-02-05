require 'gsl'

class Location < ActiveRecord::Base
  INTERPOLATION_WINDOW_SECONDS = 8

  belongs_to :trackable, polymorphic: true
  reverse_geocoded_by :latitude, :longitude

  validates :latitude, :longitude, presence: true
  validates_presence_of :trackable, :timestamp

  scope :in_order, -> { order(timestamp: :asc) }
  scope :with_timestamp, -> { where.not(timestamp: nil) }

  def coords
    [latitude, longitude]
  end

  def self.during(start_at, end_at)
    where(during_arel(start_at, end_at))
  end

  def self.can_interpolate?(time, locations)
    locations.count >= 3 &&
      time >= locations.first.timestamp &&
      time <= locations.last.timestamp
  end

  def self.to_time_ms(datetime)
    (datetime.to_f * 1000).to_i
  end

  def self.spline(values, timestamps)
    timestamps_v = GSL::Vector.alloc(timestamps)
    values_v = GSL::Vector.alloc(values)
    spline = GSL::Spline.alloc('cspline', values.length)
    spline.init(timestamps_v, values_v)
    spline
  end

  def self.lat_spline(locations)
    timestamps = locations.map { |loc| (loc.timestamp.to_f * 1000).to_i }
    lats = locations.map(&:latitude)
    spline(lats, timestamps)
  end

  def self.long_spline(locations)
    timestamps = locations.map { |loc| (loc.timestamp.to_f * 1000).to_i }
    longs = locations.map(&:longitude)
    spline(longs, timestamps)
  end

  def self.before(end_at)
    locs = arel_table
    where(locs[:timestamp].lteq(end_at))
  end

  def self.during_arel(start_at, end_at)
    locs = arel_table
    locs[:timestamp]
      .eq(nil)
      .or(locs[:timestamp].lteq(end_at).and(locs[:timestamp].gteq(start_at)))
  end

  def to_s
    "Location(#{id}) { latitude: #{latitude}, longitude: #{longitude}, timestamp: #{timestamp} }"
  end
end
