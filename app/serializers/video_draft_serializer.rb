class VideoDraftSerializer < DraftSerializer
  attributes :start_at, :end_at, :video

  has_one :activity
  has_many :segment_efforts

  def video
    object.source_video
  end
end
