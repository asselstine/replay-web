class SetupEvaluator < Evaluator
  attribute :setup, Setup

  def coords_at(timestamp)
    setup.coords_at(timestamp)
  end

  def coords
    coords_at(now)
  end

  # The proximity method
  def strength(activity_evaluator)
    return 0 unless setup.videos.during(frame.start_at, frame.end_at)
    Geo.distance_strength(coords, activity_evaluator.coords)
  end
end
