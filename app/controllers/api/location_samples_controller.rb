class Api::LocationSamplesController < Api::BaseController

  skip_before_filter :verify_authenticity_token

  def create
    @ride = current_user.rides.first
    if @ride.nil?
      @ride = current_user.rides.create
    end
    @location = LocationSample.create(create_params.merge('ride' => @ride))
    render :create, :status => :created
  end

  protected

  def create_params
    params.require(:location_sample).permit(:latitude, :longitude, :timestamp)
  end

end