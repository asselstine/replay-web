class UploadsController < LoggedInController
  before_action :find_upload, except: [:new, :create, :index]

  def index
    @uploads = current_user.uploads
  end

  def new
    @upload = Upload.new
    @upload.build_video
  end

  def create
    @upload = Upload.create(upload_params)
    if @upload.persisted?
      redirect_to @upload, notice: I18n.t('flash.activerecord.create.success')
    else
      render 'new'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.json do
          render json: @upload,
                 notice: I18n.t('flash.activerecord.update.success')
        end
        format.html do
          redirect_to @upload,
                      notice: I18n.t('flash.activerecord.update.success')
        end
      else
        format.json do
          render json: @upload, status: :unprocessible_entity
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

  def upload_params
    uparams = params.require(:upload)
                    .permit(:start_at,
                            :end_at,
                            video_attributes: [:id,
                                               :source_url,
                                               :file])
                    .merge(user: current_user)
    uparams[:video_attributes][:user] = current_user
    uparams
  end

  def find_upload
    @upload = Upload.find(params[:id])
  end
end
