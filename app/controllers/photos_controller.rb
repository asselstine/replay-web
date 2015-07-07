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
    if @photo.persisted?
      redirect_to @photo
    else
      render 'new'
    end
  end

  protected

  def create_params
    params.require(:photo).permit(:image)
  end

end