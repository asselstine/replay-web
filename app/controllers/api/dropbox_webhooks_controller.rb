require 'openssl'

module Api
  class DropboxWebhooksController < BaseController
    before_action :check_challenge
    before_action :validate_header

    def webhook
      json = JSON.parse(request.body)
      return unless json['delta'].present?
      json['delta']['users'].each do |user_id|
        Rails.logger.debug("Processing updates for user #{user_id}")
      end
    end

    private

    def check_challenge
      render text: params[:challenge].to_s if params[:challenge]
    end

    # rubocop:disable Metrics/AbcSize
    def validate_header
      signature = request.headers['X-Dropbox-Signature']
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.digest(digest,
                                  Rails.application.secrets.dropbox_app_secret,
                                  request.body)
      return unless hmac == signature
      Rails.logger.debug('Rejecting invalid Dropbox webhook call.')
      render(file: File.join(Rails.root, 'public/403.html'),
             status: 403,
             layout: false)
    end
  end
end
