class CamerasController < RecordingSessionsNestedController 
  def new
    @camera = Camera.new(recording_session: @recording_session)
  end

  def create
    @camera = Camera.create(create_params)
    if @camera.persisted?
      redirect_to [@recording_session, @camera]
    else
      render 'new'
    end
  end

  def show
    @camera = Camera.find(params[:id])
  end

  protected

  def create_params
    params.require(:camera).permit(:name).merge(recording_session: @recording_session)
  end
end
