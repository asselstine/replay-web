class CamerasController < RecordingSessionsNestedController 
  before_action :find_camera, except: [:new, :create]
  def new
    @camera = Camera.new(recording_session: @recording_session)
    @camera.locations.build
  end

  def create
    @camera = Camera.create(camera_params)
    if @camera.persisted?
      redirect_to [@recording_session, @camera]
    else
      binding.pry
      render 'new'
    end
  end

  def show
  end

  def edit
    @camera.locations.build if @camera.locations.empty?
  end

  def update
    if @camera.update(camera_params)
      redirect_to [@recording_session, @camera], notice: I18n.t('flash.activerecord.create.success')
    else
      render 'edit'
    end
  end

  protected

  def camera_params
    params.require(:camera)
      .permit(:name, :range_m, locations_attributes: [:timestamp, :latitude, :longitude] )
      .merge(recording_session: @recording_session)
  end

  def find_camera
    @camera = Camera.find(params[:id])
  end
end
