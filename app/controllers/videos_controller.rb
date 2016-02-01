class VideosController < LoggedInController
  before_action :find_video, except: [:new, :create]

  def new
    @video = Video.new(create_params)
  end

  def create
    @video = Video.create(create_params)
    if @video.persisted?
      redirect_to @video
    else
      render 'new'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      if @video.update(create_params)
        format.json do
          render json: @video,
                 notice: I18n.t('flash.activerecord.update.success')
        end
        format.html do
          redirect_to @video.camera,
                      notice: I18n.t('flash.activerecord.update.success')
        end
      else
        format.json do
          render json: @video, status: :unprocessible_entity
        end
        format.html do
          render 'new'
        end
      end
    end
  end

  def show
  end

  protected

  def create_params
    params.require(:video).permit(:start_at,
                                  :end_at,
                                  :duration_ms,
                                  :source_key,
                                  :camera_id,
                                  :filename)
  end

  def find_video
    @video = Video.find(params[:id])
  end
end
