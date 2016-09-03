class VideoUpload < Upload
  belongs_to :video
  has_many :jobs, through: :video

  validates_presence_of :video

  accepts_nested_attributes_for :video

  scope :during, (lambda do |start_at, end_at|
    joins(:video).merge(Video.during(start_at, end_at))
  end)

  after_save :check_video_start_at_changed

  scope :oldest_by_video_start_at, (lambda do
    joins(:video).order('videos.start_at ASC')
  end)

  scope :newest_by_video_end_at, (lambda do
    joins(:video).order('videos.end_at DESC')
  end)

  private

  def check_video_start_at_changed
    return unless video_timestamps_changed?
    resync
  end

  def video_timestamps_changed?
    (video.start_at_changed? || video.previous_changes[:start_at].present?) &&
      video.start_at.present? &&
      video.end_at.present?
  end

  def resync
    sync_strava
    draft_videos
  end

  def sync_strava
    StravaActivitySync.call(user: user,
                            start_at: video.start_at.ago(1.hour),
                            end_at: video.end_at.since(1.hour))
  end

  def draft_videos
    VideoDrafter.call(start_at: video.start_at,
                      end_at: video.end_at,
                      setups: setups)
  end
end
