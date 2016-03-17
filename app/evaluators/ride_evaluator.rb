class RideEvaluator < Evaluator
  include Virtus.model

  attribute :ride

  def coords
    location_evaluator.coords_at(now)
  end

  def location_evaluator
    @location_evaluator ||= LocationEvaluator.new(locations: ride.locations)
  end
end
