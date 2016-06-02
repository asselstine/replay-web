class CreateVideoThumbnailJob < ActiveJob::Base
  queue_as :default

  def perform(video:)
    FFMPEG::Thumbnail.call(video: video)
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
