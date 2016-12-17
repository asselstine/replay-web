class VideoDraftSerializer < DraftSerializer
  has_one :video

  def video
    object.source_video
  end
end
