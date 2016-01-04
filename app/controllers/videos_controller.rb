class VideosController < CamerasNestedController
  def create
    @video = Video.create(create_params)
    if @video.persisted?
      redirect_to @video
    else
      redirect_to @camera
    end  
  end

  protected

  def create_params
    params.require(:video).permit(:start_at).merge(camera: @camera)
  end
end 
