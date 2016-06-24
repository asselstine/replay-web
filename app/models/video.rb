class Video < ActiveRecord::Base
  mount_uploader :file, VideoUploader
  belongs_to :thumbnail, class_name: Photo
  belongs_to :user
  has_many :video_drafts
  has_many :scrub_images

  validates_presence_of :file
  validates_presence_of :user

  scope :during, (lambda do |start_at, end_at|
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order(start_at: :asc)
  end)
end
