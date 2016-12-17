class VideoDraft < Draft
  belongs_to :source_video, class_name: 'Video'
  belongs_to :activity

  has_many :segment_efforts,
           (lambda do |video_draft|
             merge(SegmentEffort.during(video_draft.start_at, video_draft.end_at))
           end),
           through: :activity

  validates_presence_of :source_video, :start_at, :end_at
end
