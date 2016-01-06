module ContextFactory
  def self.from_ride(ride)
    locations = ride.locations.with_timestamp.in_order
    start_at = locations.first.timestamp
    end_at = locations.last.timestamp
    Context.new(start_at: start_at, end_at: end_at)
  end
end
