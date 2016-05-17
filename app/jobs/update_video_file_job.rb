class UpdateVideoFileJob < ActiveJob::Base
  queue_as :default

  def perform(video:)
    video.reload
    video.remote_file_url = video.source_url
    Rails.logger.error(<<-STRING
      Could not UpdateVideoFile for video with id #{video.id}
    STRING
                      ) unless video.save
    begin
      FFMPEG::Thumbnail.call(video: video)
    rescue StandardError => e
      Rails.logger.error(e)
    end
  end
end
