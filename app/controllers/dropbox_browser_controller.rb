class DropboxBrowserController < ApplicationController
  before_action :authenticate_user!

  include DropboxConcern

  def index
    path = params[:path] || '/'
    @metadata ||= metadata(path)
    @dropbox_event = dropbox_event(path)
  end

  protected

  def dropbox_event(path)
    DropboxEvent.find_by_path(path) if path.present?
  end
end
