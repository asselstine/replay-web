module SegmentEfforts
  class DraftSerializer < ModelSerializer
    attributes :name,
               :type

    has_one :video

    def video
      object.source_video
    end
  end
end
