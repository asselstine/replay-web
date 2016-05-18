class VideoSerializer < BaseSerializer
  attributes :start_at,
             :end_at,
             :duration,
             :filename,
             :file_url,
             :status,
             :message,
             :job_id
  has_one :thumbnail
end
