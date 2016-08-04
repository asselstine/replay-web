class VideoDraft < Draft
  belongs_to :source_video, class_name: 'Video'
  belongs_to :video

  validates_presence_of :source_video, :start_at, :end_at

  after_save :slice_draft, if: 'video.blank?'

  def slice_draft
    DraftSlicerJob.perform_later(draft_id: id)
  end
end
