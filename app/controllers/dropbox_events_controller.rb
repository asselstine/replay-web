class DropboxEventsController < ApplicationController
  load_and_authorize_resource

  include DropboxConcern

  def index
    @dropbox_events = DropboxEvent.all
  end

  def create
    @dropbox_event = DropboxEvent.create(
      create_params.merge('user' => current_user)
    )
    if @dropbox_event.persisted?
      redirect_to @dropbox_event
    else
      flash[:error] =
        "Unable to create Dropbox: #{@dropbox_event.errors.full_messages}"
      redirect_to :back
    end
  end

  def show
    @dropbox_event = DropboxEvent.find(params[:id])
  end

  protected

  def create_params
    params.require(:dropbox_event).permit(:path)
  end
end
