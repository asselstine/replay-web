class LocationSamplesController < ApplicationController

  def index
    @location_samples = LocationSample.all
  end

end