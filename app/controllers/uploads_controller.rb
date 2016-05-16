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
      render json: @upload, status: :ok
    else
      render json: @upload, status: :unprocessible_entity
    end
  end

  def update
    if @upload.update(upload_params)
      render json: @upload, status: :ok
    else
      render json: @upload, status: :unprocessible_entity
    end
  end

  def show
  end

  protected

  def upload_params
    params.require(:upload)
          .permit(:start_at,
                  :end_at,
                  video_attributes: [:id,
                                     :source_url,
                                     :file,
                                     :filename],
                  setup_ids: [])
          .merge(user: current_user)
  end

  def find_upload
    @upload = Upload.find(params[:id])
  end
end
