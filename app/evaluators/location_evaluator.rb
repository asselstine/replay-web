class LocationEvaluator < Evaluator
  include Virtus.model

  attribute :locations

  def coords_at(time)
    return nil unless Location.can_interpolate?(time, locations)
    time_ms = Location.to_time_ms(time)
    [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
  end

  def coords
    coords_at(now)
  end

  protected

  def lat_spline
    @lat_spline ||= Location.lat_spline(locations)
  end

  def long_spline
    @long_spline ||= Location.long_spline(locations)
  end
end
