class VideoUpload < Upload
  belongs_to :video
  validates_presence_of :video
  accepts_nested_attributes_for :video

  scope :during, (lambda do |start_at, end_at|
    joins(:video).merge(Video.during(start_at, end_at))
  end)
end
