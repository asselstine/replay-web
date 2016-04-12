class RidesController < ApplicationController
  load_and_authorize_resource
  include SetRide
  before_action :set_ride, only: [:show, :recut]

  def index
    @rides = Ride.all
  end

  def show
  end

  def recut
    RoughCutEditor.call(ride: @ride)
    redirect_to @ride
  end
end
