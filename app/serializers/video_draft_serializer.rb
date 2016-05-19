class VideoDraftSerializer < DraftSerializer
  attributes :start_at, :end_at
  has_one :video
end
