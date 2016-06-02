class PhotoUpload < Upload
  belongs_to :photo
  validates_presence_of :photo

  scope :during, (lambda do |start_at, end_at|
    joins(:photo).merge(Photo.during(start_at, end_at))
  end)
end
