class VideoDraft < Draft
  validates_presence_of :start_at, :end_at
  belongs_to :video
end
