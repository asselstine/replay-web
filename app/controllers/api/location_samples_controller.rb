class Api::LocationSamplesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    @location = LocationSample.create(location_params)
    render :create, :status => :created
  end

  private

  def location_params
    params.require(:location_sample).permit(:latitude, :longitude, :timestamp)
  end

end