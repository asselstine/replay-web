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

  def self.url_to_s3_key(url)
    uri = URI(url)
    uri.path.gsub("/#{Figaro.env.aws_s3_bucket}/", '')
  end

  private

  def process_video(upload)
    upload = upload.becomes! VideoUpload
    upload.create_video!(user: upload.user,
                         file: self.class.url_to_s3_key(upload.url))
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
