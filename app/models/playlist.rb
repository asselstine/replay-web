class Playlist < ActiveRecord::Base
  include QuasiCarrierWave

  has_many :streams

  validates :key, presence: true

  def file_url
    fog_file_from_key(key).public_url
  end

  private

  def uploader_class
    HlsUploader
  end
end
