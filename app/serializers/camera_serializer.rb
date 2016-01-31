class CameraSerializer < BaseSerializer
  attributes :id,
             :range_m,
             :recording_session_id,
             :static,
             :one_time,
             :name
end
