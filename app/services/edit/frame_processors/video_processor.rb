module Edit
  module FrameProcessors
    class VideoProcessor < FrameProcessor
      include Virtus.model

      attribute :selector, Edit::Selector
      attribute :video_drafts, Array[VideoDraft], default: []

      def process(frame)
        comparator = selector.select(frame)
        return unless comparator
        frame_start_at = draft_start_at(frame, comparator)
        frame_end_at = draft_end_at(frame, comparator)
        if continue_current_draft(comparator, frame_start_at)
          @video_drafts.last.end_at = frame_end_at
        else
          @video_drafts << VideoDraft.new(activity: comparator.activity,
                                          setup: comparator.setup,
                                          source_video: comparator.video,
                                          start_at: frame_start_at,
                                          end_at: frame_end_at,
                                          name: comparator.activity.strava_name)
        end
        frame_end_at
      end

      def draft_start_at(frame, comparator)
        [frame.start_at, comparator.video.start_at].max
      end

      def draft_end_at(frame, comparator)
        [frame.end_at, comparator.video.end_at].min
      end

      def continue_current_draft(comparator, start_at)
        @video_drafts.any? &&
          @video_drafts.last.source_video == comparator.video &&
          @video_drafts.last.end_at == start_at
      end
    end
  end
end
