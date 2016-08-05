# Turns out SegmentEffortVideoStrategy was not needed- drafts are simply about
# portions of video uploads that are good candidates for the user's feed.
module Edit
  module VideoDraftingStrategies
    class SegmentEffortVideoStrategy < VideoDraftingStrategy
      def continue_draft?(frame, comparator, draft)
        continuing = draft &&
                     draft.source_video == comparator.video &&
                     draft.end_at == effort_video_start_at(frame, comparator) &&
                     draft.segment_effort == comparator.segment_effort
        return false unless continuing
        draft.end_at = effort_video_end_at(frame, comparator)
        true
      end

      def new_draft(frame, comparator)
        VideoDraft.new(activity: comparator.activity,
                       segment_effort: comparator.segment_effort,
                       setup: comparator.setup,
                       source_video: comparator.video,
                       start_at: effort_video_start_at(frame, comparator),
                       end_at: effort_video_end_at(frame, comparator),
                       name: comparator.segment_effort.name)
      end

      def effort_video_start_at(frame, comparator)
        [
          draft_start_at(frame, comparator),
          comparator.segment_effort.start_at
        ].max
      end

      def effort_video_end_at(frame, comparator)
        [
          draft_end_at(frame, comparator),
          comparator.segment_effort.end_at
        ].min
      end
    end
  end
end
