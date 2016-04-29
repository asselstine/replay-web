class UpdatePhotoFileJob < ActiveJob::Base
  queue_as :default

  def perform(photo:)
    photo.reload
    photo.remote_image_url = photo.source_url
    Rails.logger.error(<<-STRING
      Could not UpdatePhotoFile for photo with id #{photo.id}
    STRING
                      ) unless photo.save
  end
end
