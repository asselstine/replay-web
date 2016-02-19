class Video < ActiveRecord::Base
  mount_uploader :file, VideoUploader

  validates_presence_of :source_url, if: (proc do |v|
    v.file.blank?
  end)
  validates_presence_of :file, if: proc { |v| v.source_url.blank? }

  belongs_to :camera, inverse_of: :videos

  after_save :update_file

  def self.during(start_at, end_at)
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order('start_at ASC')
  end

  def self.containing(start_at, end_at = start_at)
    where('start_at <= ? AND end_at >= ?', start_at, end_at)
  end

  def update_file
    return unless source_url.present? && source_url_changed?
    UpdateVideoFileJob.perform_later(video: self)
  end
end
