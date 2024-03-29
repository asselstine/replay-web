class SegmentEffortSerializer < ApplicationSerializer
  attributes :name, :start_index, :end_index

  has_many :drafts, serializer: SegmentEfforts::DraftSerializer
end
