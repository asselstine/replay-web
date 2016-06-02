class ProcessUploadJob < ActiveJob::Base
  queue_as :default

  def perform(upload:)
    ActiveRecord::Base.clear_active_connections!
    upload.reload
    if /video/ =~ upload.file_type
      process_video(upload)
    elsif /image/ =~ upload.file_type
      process_photo(upload)
    else
      process_error(upload)
    end
    upload.save!
  rescue StandardError => e
    Rails.logger.error(e)
  end

  private

  def process_video(upload)
    upload = upload.becomes! VideoUpload
    video = upload.create_video!(user: upload.user,
                                 remote_file_url: upload.url)
    FFMPEG::Thumbnail.call(video: video)
  end

  def process_photo(upload)
    upload = upload.becomes! PhotoUpload
    upload.create_photo!(user: upload.user,
                         remote_image_url: upload.url)
  end

  def process_error(upload)
    upload.process_msg = "Unknown file type: #{upload.file_type}"
  end
end
