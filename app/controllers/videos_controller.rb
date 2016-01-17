class VideosController < CamerasNestedController
  before_action :find_video, only: [:show]
  
  def new
    @video = Video.new
  end

  def create
    @video = Video.create(create_params)
    if @video.persisted?
      redirect_to recording_session_camera_path(id: @camera.id)
    else
      render 'new'
    end  
  end

  def show
  end

  protected

  def create_params
    params.require(:video).permit(:start_at, :source_key, :filename).merge(camera: @camera)
  end

  def find_video
    @video = Video.find(params[:id])
  end
end 
