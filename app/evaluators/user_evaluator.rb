class UserEvaluator < Evaluator
  attribute :user, User

  def coords 
    time = context.cut_start_at
    return nil unless Location.can_interpolate?(time, user_locations)
    time_ms = Location.to_time_ms(time) 
    [lat_spline.eval(time_ms), long_spline.eval(time_ms)]
  end

  protected

  def lat_spline
    @lat_spline ||= Location.lat_spline(user_locations)
  end

  def long_spline
    @long_spline ||= Location.long_spline(user_locations)
  end

  def user_locations
    @locations ||= user.locations.order(timestamp: :asc).during(context.start_at, context.end_at)
  end
end
