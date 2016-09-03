class DirectUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog
end
