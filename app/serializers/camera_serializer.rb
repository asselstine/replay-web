class CameraSerializer < BaseSerializer
  attributes :range_m,
             :recording_session_id,
             :static,
             :one_time,
             :name
end
