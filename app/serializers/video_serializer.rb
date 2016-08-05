class VideoSerializer < ModelSerializer
  attributes :start_at,
             :end_at,
             :duration,
             :filename,
             :file_url,
             :status,
             :message,
             :job_id,
             :scrub_images
  has_one :thumbnail

  def scrub_images
    object.scrub_images.order(index: :asc).map do |scrub_image|
      scrub_image.image.url
    end
  end
end
