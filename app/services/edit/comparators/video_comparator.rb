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
        @video = if cache_start_at && cache_end_at
                   cached_video_during_frame(frame)
                 else
                   first_video(frame)
                 end
        Rails.logger.debug("Comparators::VideoComparator: video_during_frame?: #{@video}, frame: #{frame}")
        @video.present?
      end

      def first_video(frame)
        setup.videos_during(frame.start_at, frame.end_at).first
      end

      def cached_video_during_frame(frame)
        @videos ||= setup.videos_during(cache_start_at, cache_end_at)
                         .order(start_at: :asc).to_a
        @videos.bsearch do |video|
          video.start_at <= frame.end_at &&
            video.end_at > frame.start_at
        end
      end
    end
  end
end
