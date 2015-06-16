class Api::LocationSamplesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    @ride = Ride.find_by_username(params[:username])
    if @ride.nil?
      @ride = Ride.create(:username => params[:username])
    end
    @location = LocationSample.create(location_params.merge('ride' => @ride))
    render :create, :status => :created
  end

  private

  def location_params
    params.require(:location_sample).permit(:latitude, :longitude, :timestamp)
  end

end