class VideoSerializer < BaseSerializer
  attributes :source_url,
             :start_at,
             :end_at,
             :duration,
             :filename,
             :file_url,
             :status,
             :message,
             :job_id
end
