class VideoSerializer < BaseSerializer
  attributes :id,
             :source_key,
             :start_at,
             :end_at,
             :duration_ms,
             :filename,
             :webm_url,
             :mp4_url,
             :status,
             :message,
             :job_id

  attributes :complete?
end
