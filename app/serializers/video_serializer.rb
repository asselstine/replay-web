class VideoSerializer < BaseSerializer
  attributes :id,
             :source_url,
             :start_at,
             :end_at,
             :duration_ms,
             :filename,
             :file_url,
             :status,
             :message,
             :job_id
end
