module Edit
  module FrameProcessors
    class PhotoProcessor < FrameProcessor
      include Virtus.model

      attribute :selector, Edit::Selector

      def process(frame)
        comparator = selector.select(frame)
        return unless comparator
        photos_during(frame, comparator)
      end

      def photos_during(frame, comparator)
        comparator.photos.during(frame.start_at, frame.end_at).each do |photo|
          @drafts << PhotoDraft.new(photo: photo,
                                    setup: comparator.setup,
                                    activity: comparator.activity,
                                    name: photo.filename)
        end
      end
    end
  end
end
