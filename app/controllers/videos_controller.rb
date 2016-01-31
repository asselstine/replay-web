class VideosController < CamerasNestedController
  before_action :find_video, except: [:new, :create]
  
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

  def update
    if @video.update(create_params)
      render json: @video, notice: 'Success!'
    else
      render json: @video, status: :unprocessible_entity
    end
  end

  def show
  end

  protected

  def create_params
    params.require(:video).permit(:start_at, :end_at, :duration_ms, :source_key, :filename).merge(camera: @camera)
  end

  def find_video
    @video = Video.find(params[:id])
  end
end 
