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
        {
          src: output.public_url,
          type: output.type
        }
      end
    end.flatten
  end
end
