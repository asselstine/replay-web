class RideEvaluator < Evaluator
  include Virtus.model

  attribute :ride

  def coords
    location_evaluator.coords_at(now)
  end

  protected

  def location_evaluator
    @location_evaluator ||= LocationEvaluator.new(locations: ride_locations)
  end

  def ride_locations
    @locations ||= ride.locations
                       .order(timestamp: :asc)
                       .during(frame.start_at - 10.minutes,
                               frame.end_at + 10.minutes)
  end
end
