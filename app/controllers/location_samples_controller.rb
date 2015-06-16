class LocationSamplesController < ApplicationController

  load_and_authorize_resource

  def index
    @location_samples = LocationSample.all
  end

  def clear
    LocationSample.destroy_all
  end

end