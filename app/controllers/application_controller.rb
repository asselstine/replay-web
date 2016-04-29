require 'time'

class ApplicationController < ActionController::Base
  before_action :set_date_header, unless: 'Rails.env.production?'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def set_date_header
    response.header['X-Date'] = Time.now.httpdate
  end

  def ajax_notice(msg)
    flash.keep(:notice)
    flash[:notice] = msg
  end
end
