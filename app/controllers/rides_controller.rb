class RidesController < ApplicationController

  before_action :set_ride, :only => [:show]

  def index
    @rides = Ride.all
  end

  def show
  end

  private

  def set_ride
    @ride = Ride.find( params.require(:id) )
  end


end