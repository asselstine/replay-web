module Edit
  module Comparators
    class VideoComparator < Edit::Comparator
      # Output attribute
      attribute :video, Video

      def compute_strength(frame)
        @strength = if video_during_frame?(frame)
                      distance_strength(frame)
                    else
                      0
                    end
      end

      protected

      def video_during_frame?(frame)
        @video = setup.videos_during(frame).first
        @video.present?
      end
    end
  end
end
