module Edit
  class VideoUploadActivitySelectors
    include Virtus.model
    include Service

    attribute :video_upload

    def call
      # A strange interface for a single comparator.  But it's consistent.
      comparators.map do |comparator|
        Edit::Selector.new(comparators: [comparator])
      end
    end

    def comparators
      Activity.during(video_upload.video.start_at,
                      video_upload.video.end_at).map do |activity|
        video_upload.setups.map do |setup|
          Edit::Comparators::VideoComparator.new(activity: activity,
                                                 setup: setup)
        end
      end.flatten
    end
  end
end
