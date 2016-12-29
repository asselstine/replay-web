class OutputSerializer < ApplicationSerializer
  attributes :signed_url,
             :container_format,
             :thumbnail_urls

  def thumbnail_urls
    object.thumbnail_keys.map do |key|
      S3.object(object.job.full_key(key)).public_url
    end
  end
end
