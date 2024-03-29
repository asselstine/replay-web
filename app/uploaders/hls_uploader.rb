# encoding: utf-8

class HlsUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "hls/playlist-#{model.id}"
  end
end
