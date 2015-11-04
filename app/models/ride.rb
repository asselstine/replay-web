class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :location_samples, -> {
    order('timestamp_in_seconds DESC')
  }
  accepts_nested_attributes_for :location_samples

  #interpolates the 5 points before and 5 after
  def interpolate(location_sample)

    samples = location_samples.preceding(location_sample.timestamp, 5) + [location_sample] + location_samples.following(location_sample.timestamp, 5)

    if samples.length > (MIN_POINTS-1) && samples.first.timestamp_in_seconds != samples.last.timestamp_in_seconds
      oldest = samples.first
      #destroy interpolated values
      location_samples.interpolated.between(samples.first.timestamp, samples.last.timestamp).destroy_all
      timestamps = GSL::Vector.alloc( samples.map { |s| s.timestamp_in_seconds } )
      lats = GSL::Vector.alloc( samples.map { |s| s.latitude } )
      longs = GSL::Vector.alloc( samples.map { |s| s.longitude } )

      lat_spline = GSL::Spline.alloc('cspline',samples.length)
      lat_spline.init(timestamps, lats)
      long_spline = GSL::Spline.alloc('cspline', samples.length)
      long_spline.init(timestamps, longs)

      curr_time = oldest.timestamp_in_seconds + INTERP_STEP
      final_time = timestamp_in_seconds

      while curr_time < final_time
        ls = LocationSample.create({:interpolated => true,
                                    :ride_id => ride.id,
                                    :latitude => lat_spline.eval(curr_time.to_f),
                                    :longitude => long_spline.eval(curr_time.to_f),
                                    :timestamp_in_seconds => curr_time})
        raise "Could not interpolate: #{ls.errors.full_messages}" unless ls.persisted?
        curr_time += INTERP_STEP
      end

    end
  end


end
