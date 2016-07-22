class VideoUpload < Upload
  belongs_to :video
  validates_presence_of :video
  accepts_nested_attributes_for :video

  scope :during, (lambda do |start_at, end_at|
    joins(:video).merge(Video.during(start_at, end_at))
  end)

  after_save :check_video_start_at_changed

  private

  def check_video_start_at_changed
    return unless video.start_at_changed?
    Edit::CreateVideoDraftsFromUpload.call(video_upload: self)
  end
end
