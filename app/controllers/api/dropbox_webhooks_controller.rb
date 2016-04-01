require 'openssl'

class Api::DropboxWebhooksController < Api::BaseController

  before_action :check_challenge
  before_action :validate_header

  def webhook
    json = JSON.parse(request.body)
    if json['delta'].present?
      json['delta']['users'].each do |user_id|
        Rails.logger.debug("Processing updates for user #{user_id}")
      end
    end
  end

  private

  def check_challenge
    if params[:challenge]
      render text: "#{params[:challenge]}"
    end
  end

  def validate_header
    signature = request.headers['X-Dropbox-Signature']
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.digest(digest, Rails.application.secrets.dropbox_app_secret, request.body)
    if hmac != signature
      Rails.logger.debug("Rejecting invalid Dropbox webhook call.")
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end
  end

end
