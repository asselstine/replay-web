class VideoSerializer < ModelSerializer
  attributes :start_at,
             :end_at,
             :duration,
             :filename,
             :file_url,
             :status,
             :message,
             :job_id,
             :scrub_images,
             :sources

  has_one :thumbnail
  has_many :playlists

  def scrub_images
    []
  end

  def sources
    object.web_jobs.map do |job|
      job.outputs.map do |output|
        src = S3.object(job.full_key(output.key))
                .presigned_url(:get, expires_in: 1.hour)
        {
          src: src,
          type: "video/#{output.container_format}"
        }
      end
    end.flatten
  end
end
