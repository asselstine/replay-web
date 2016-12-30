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

  has_many :outputs

  def scrub_images
    []
  end

  def outputs
    object.current_job&.outputs || []
  end
end
