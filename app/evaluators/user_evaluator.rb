class UserEvaluator < Evaluator
  attribute :user, User

  def coords_at(time)
    return nil unless Location.can_interpolate?(time, user_locations)
    time_ms = Location.to_time_ms(time)
    [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
  end

  def coords
    coords_at(context.cut_start_at)
  end

  protected

  def lat_spline
    @lat_spline ||= Location.lat_spline(user_locations)
  end

  def long_spline
    @long_spline ||= Location.long_spline(user_locations)
  end

  def user_locations
    @locations ||= user.locations.order(timestamp: :asc).during(context.start_at - 10.minutes, context.end_at + 10.minutes)
  end
end
