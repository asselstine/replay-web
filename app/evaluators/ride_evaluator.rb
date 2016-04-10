class RideEvaluator < Evaluator
  include Virtus.model

  attribute :ride

  def coords
    ride.time_series_data.coords_at(now)
  end
end
