class VideoDraft < Draft
  belongs_to :source_video, class_name: 'Video'
  belongs_to :video
  belongs_to :segment_effort

  validates_presence_of :source_video, :start_at, :end_at
end
