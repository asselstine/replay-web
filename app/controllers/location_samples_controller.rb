class LocationSamplesController < ApplicationController

  def index
    @location_samples = LocationSample.all
  end

  def clear
    LocationSample.destroy_all
  end

end