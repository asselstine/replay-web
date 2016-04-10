class UserEvaluator < Evaluator
  attribute :user, User

  def coords
    user.time_series_data.each do |time_series|
      cords = time_series.coords_at(now)
      return cords if cords.any?
    end
    nil
  end
end
