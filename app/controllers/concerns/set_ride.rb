module SetRide
  extend ActiveSupport::Concern

  included do
    def set_ride
      @ride = Ride.find(params.require(:id))
    end
  end
end
