class Output < ActiveRecord::Base
  enum media_type: {
    video: 0,
    audio: 1
  }
  belongs_to :job

  after_destroy :remove_s3_objects

  def signed_url
    return key if Rails.env.test?
    S3.object(job.full_key(key))
      .presigned_url(:get, expires_in: 1.hour)
  end

  def thumbnail_url_pattern
    S3.object(job.full_key(key))
      .presigned_url(:get, expires_in: 1.hour)
  end

  def thumbnail_count
    return 0 unless duration_millis && thumbnail_interval_s
    (duration_millis / (thumbnail_interval_s * 1000)) + 1
  end

  def thumbnail_keys
    (1..thumbnail_count).map do |i|
      key = thumbnail_pattern.gsub('{count}', i.to_s.rjust(5, '0'))
      "#{key}.#{thumbnail_format}"
    end
  end

  def thumbnail_urls
    thumbnail_keys.map do |key|
      if Rails.env.test?
        key
      else
        S3.object(job.full_key(key)).public_url
      end
    end
  end

  private

  def remove_s3_objects
    thumbnail_keys.each do |thumbnail_key|
      S3.object(job.full_key(thumbnail_key)).delete
    end
    S3.object(job.full_key(key)).delete
  end
end
