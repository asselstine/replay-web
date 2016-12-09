class UploadsController < LoggedInController
  before_action :find_upload, except: [:new, :create, :index]

  def index
    @uploads = current_user.uploads
  end

  def create
    @upload = Upload.create(create_params)
    if @upload.persisted?
      render json: @upload, status: :ok
    else
      render json: @upload, status: :unprocessible_entity
    end
  end

  def update
    if @upload.update(update_params)
      @upload.check_video_start_at_changed if @upload.is_a? VideoUpload
      render json: @upload, status: :ok
    else
      render json: @upload, status: :unprocessible_entity
    end
  end

  protected

  def create_params
    params.require(:upload)
          .permit(:url,
                  :file,
                  :filename,
                  :file_type,
                  :file_size,
                  :unique_id,
                  setup_ids: [])
          .merge(user: current_user)
  end

  def update_params
    params.require(:upload)
          .permit(video_attributes: [
                    :id,
                    :start_at,
                    :end_at
                  ],
                  setup_ids: [])
  end

  def find_upload
    @upload = Upload.find(params[:id])
  end
end
