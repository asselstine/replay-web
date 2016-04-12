require 'dropbox_sdk'
require 'ostruct'

module DropboxConcern
  extend ActiveSupport::Concern

  included do
    def metadata(path = '/')
      metadata = client.metadata(path)
      OpenStruct.new( metadata )
    end

    def client
      @client ||= DropboxClient.new( current_user.access_token )
    end
  end
end
