class Video < ActiveRecord::Base
  mount_uploader :file, VideoUploader
  validates_presence_of :source_url, if: (proc do |v|
    v.file.blank?
  end)
  validates_presence_of :file, if: proc { |v| v.source_url.blank? }

  after_save :check_source_url

  def check_source_url
    return unless source_url.present? && source_url_changed?
    UpdateVideoFileJob.perform_later(video: self)
  end
end
