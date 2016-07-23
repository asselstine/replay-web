module Edit
  module Comparators
    class SegmentComparator < VideoComparator
      attribute :segment_effort, SegmentEffort

      def compute_strength(frame)
        @strength = if video_during_frame?(frame) &&
                       segment_effort_during_frame?(frame)
                      distance_strength(frame)
                    else
                      0
                    end
      end

      protected

      def segment_effort_during_frame?(frame)
        @segment_effort = activity.segment_efforts.during(frame.start_at).first
        @segment_effort.present?
      end
    end
  end
end
