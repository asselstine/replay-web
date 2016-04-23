class UploadSerializer < BaseSerializer
  attributes :user_id, :start_at, :end_at
  has_one :video
end
