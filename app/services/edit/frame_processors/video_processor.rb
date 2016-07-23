module Edit
  module FrameProcessors
    class VideoProcessor < FrameProcessor
      include Virtus.model

      attribute :selector, Edit::Selector
      attribute :video_drafts, Array[VideoDraft], default: []
      attribute :video_drafting_strategy,
                VideoDraftingStrategy,
                default: VideoDraftingStrategies::ActivityVideoStrategy.new

      def process(frame)
        comparator = selector.select(frame)
        return unless comparator
        return @video_drafts.last.end_at if continue_draft?(frame, comparator)
        @video_drafts << new_draft(frame, comparator)
        @video_drafts.last.end_at
      end

      def continue_draft?(frame, comparator)
        video_drafting_strategy.continue_draft?(frame,
                                                comparator,
                                                @video_drafts.last)
      end

      def new_draft(frame, comparator)
        video_drafting_strategy.new_draft(frame, comparator)
      end
    end
  end
end
