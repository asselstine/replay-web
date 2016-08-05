class LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @location = Location.all
  end

  def clear
    Location.destroy_all
  end
end
