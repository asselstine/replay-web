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
  end

  private

  def process_video(upload)
    upload.type = VideoUpload
    video = upload.create_video!(remote_file_url: upload.url)
    FFMPEG::Thumbnail.call(video: video)
  end

  def process_photo(upload)
    upload.type = PhotoUpload
    upload.create_photo!(remote_image_url: upload.url)
  end

  def process_error(upload)
    upload.process_msg = "Unknown file type: #{upload.file_type}"
  end
end
