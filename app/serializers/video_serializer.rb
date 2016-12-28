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
  has_many :playlists
  has_many :web_outputs

  def scrub_images
    []
  end
end
