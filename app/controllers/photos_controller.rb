class PhotosController < LoggedInController
  load_and_authorize_resource

  def uploaded
    @photos = current_user.photos
    render 'index'
  end

  def index
    @photos = current_user.draft_photo_photos
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.create(create_params)
    respond_to do |format|
      format.html do
        if @photo.persisted?
          redirect_to @photo,
                      notice: I18n.t('flash.activerecord.create.success')
        else
          flash[:alert] = @photo.errors.full_messages
          render 'new'
        end
      end
      format.json do
        if @photo.persisted?
          render json: { message: 'success' },
                 status: :created
        else
          render json: { message: @photo.errors.full_messages },
                 status: :unprocessable_entity
        end
      end
    end
  end

  protected

  def create_params
    params
      .require(:photo)
      .permit(:image, :source_url)
      .merge(user: current_user)
  end
end
