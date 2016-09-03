class VideoUploadSerializer < UploadSerializer
  has_one :video
  has_many :jobs
end
