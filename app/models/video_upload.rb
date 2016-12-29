class VideoUpload < Upload
  accepts_nested_attributes_for :video

  scope :during, (lambda do |start_at, end_at|
    joins(:video).merge(Video.during(start_at, end_at))
  end)

  scope :oldest_by_video_start_at, (lambda do
    joins(:video).order('videos.start_at ASC')
  end)

  scope :newest_by_video_end_at, (lambda do
    joins(:video).order('videos.end_at DESC')
  end)

  def check_video_start_at_changed
    return unless video_timestamps_changed?
    VideoUploadDrafterJob.perform_later(id)
  end

  def video_timestamps_changed?
    (video.start_at_changed? || video.previous_changes[:start_at].present?) &&
      video.start_at.present? &&
      video.end_at.present?
  end
end
