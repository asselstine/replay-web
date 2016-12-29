class Output < ActiveRecord::Base
  enum media_type: {
    video: 0,
    audio: 1
  }
  belongs_to :job

  def public_url
    return key if Rails.env.test?
    S3.object(job.full_key(key))
      .presigned_url(:get, expires_in: 1.hour)
  end

  def type
    "video/#{container_format}"
  end
end
