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
    return unless video_timestamps_changed?
    VideoDrafter.call(start_at: video.start_at,
                      end_at: video.end_at,
                      setups: setups)
  end

  def video_timestamps_changed?
    (video.start_at_changed? || video.previous_changes[:start_at].present?) &&
      video.start_at.present? &&
      video.end_at.present?
  end
end
