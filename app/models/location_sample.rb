class LocationSample < ActiveRecord::Base
  INTERP_STEP=0.25
  MIN_POINTS = 3

  belongs_to :ride

  after_save :reinterpolate

  scope :interpolated, -> {
    where(:interpolated => true)
  }

  scope :not_interpolated, -> {
    where(:interpolated => false)
  }

  composed_of :timestamp,
              :class_name => "Time",
              :mapping => %w(timestamp_in_seconds to_r),
              :constructor => Proc.new { |t| Time.at(t) },
              :converter => Proc.new { |t| t.is_a?(Time) ? t : Time.at(t/1000.0) }

  def reinterpolate
#    ride.interpolate(self)
  end

  def self.between(start_time, end_time)
    where('timestamp_in_seconds > ? AND timestamp_in_seconds < ?', start_time.to_f, end_time.to_f)
  end

  def self.preceding(timestamp, count=1)
    where('timestamp_in_seconds < ?', timestamp.to_f).order('timestamp_in_seconds DESC').limit(count)
  end

  def self.following(timestamp, count=1)
    where('timestamp_in_seconds > ?', timestamp.to_f).order('timestamp_in_seconds ASC').limit(count)
  end

  def self.closest_to(timestamp)
    before = preceding(timestamp.to_f).first
    after = following(timestamp.to_f).first
    if before && after
      (before.timestamp - timestamp).abs < (after.timestamp - timestamp).abs ? before : after
    else
      before || after
    end
  end

  reverse_geocoded_by :latitude, :longitude
end
