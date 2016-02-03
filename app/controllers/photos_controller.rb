class PhotosController < ApplicationController

  load_and_authorize_resource

  def uploaded
    @photos = current_user.photos
    render 'index'
  end

  def index
    @photos = current_user.feed_photos
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.create(create_params.merge('user' => current_user))
    respond_to do |format|
      format.html {
        if @photo.persisted?
          redirect_to @photo, notice: I18n.t('flash.activerecord.create.success')
        else
          render 'new'
        end
      }
      format.json {
        if @photo.persisted?
          render :json => { :message => 'success' }, :status => :created
        else
          render :json => { :message => @photo.errors.full_messages }, status: :unprocessable_entity
        end
      }
    end

  end

  protected

  def create_params
    params.require(:photo).permit(:image, :timestamp)
  end

end
