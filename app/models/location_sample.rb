class LocationSample < ActiveRecord::Base
  INTERP_STEP=0.25

  belongs_to :ride

  after_save :interpolate

  scope :interpolated, -> {
    where(:interpolated => true)
  }

  scope :not_interpolated, -> {
    where(:interpolated => false)
  }

  def self.preceding(timestamp, count=1)
    where('timestamp <= ?', timestamp).order('timestamp DESC').limit(count)
  end

  def self.following(timestamp, count=1)
    where('timestamp >= ?', timestamp).order('timestamp ASC').limit(count)
  end

  def self.closest_to(timestamp)
    before = preceding(timestamp).first
    after = following(timestamp).first
    if before && after
      (before.timestamp - timestamp).abs < (after.timestamp - timestamp).abs ? before : after
    else
      before || after
    end
  end

  def interpolate
    samples = ride.location_samples.not_interpolated.preceding(timestamp, 10)

    if samples.length > 2 && samples.last.timestamp != timestamp

      oldest = samples.last
      #destroy interpolated values
      ride.location_samples.interpolated.where('timestamp >= ? AND timestamp <= ?', oldest.timestamp, timestamp).destroy_all
      timestamps = GSL::Vector.alloc( samples.pluck(:timestamp).map { |time| time.to_i }.reverse )
      lats = GSL::Vector.alloc( samples.pluck(:latitude).reverse )
      longs = GSL::Vector.alloc( samples.pluck(:longitude).reverse )

      lat_spline = GSL::Spline.alloc('cspline',samples.length)
      lat_spline.init(timestamps, lats)
      long_spline = GSL::Spline.alloc('cspline', samples.length)
      long_spline.init(timestamps, longs)

      curr_time = samples.last.timestamp.to_i + INTERP_STEP
      final_time = timestamp.to_i

      while curr_time < final_time
        ls = ride.location_samples.create({:interpolated => true,
                                           :latitude => lat_spline.eval(curr_time),
                                           :longitude => long_spline.eval(curr_time),
                                           :timestamp => Time.at(curr_time)})
        raise "Could not interpolate: #{ls.errors.full_messages}" unless ls.persisted?
        curr_time += INTERP_STEP
      end

    end
  end

  reverse_geocoded_by :latitude, :longitude
end
