class UploadSerializer < BaseSerializer
  attributes :user_id, :file_type, :filename, :file_size, :url
end
