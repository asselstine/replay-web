class UserEvaluator < Evaluator
  attribute :user, User

  def coords
    location_evaluator.coords
  end

  protected

  def location_evaluator
    @location_evaluator ||= LocationEvaluator.new(locations: user_locations,
                                                  frame: frame)
  end

  def user_locations
    @locations ||= user.locations
                       .order(timestamp: :asc)
                       .during(frame.start_at - 10.minutes,
                               frame.end_at + 10.minutes)
  end
end
