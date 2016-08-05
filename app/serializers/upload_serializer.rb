class UploadSerializer < ModelSerializer
  attributes :type, :user_id, :file_type, :filename, :file_size, :url
end
