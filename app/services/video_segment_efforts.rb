class VideoSegmentEfforts
  include Virtus.model
  include Service

  attribute :video_upload, VideoUpload

  def call
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        Edit::VideoProcessor.call(
          selector: selector,
          video_drafting_strategy: strategy
        )
      end
    end
  end

  def strategy
    Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy.new
  end

  def selectors
    # A strange interface for a single comparator.  But it's consistent.
    comparators.map do |comparator|
      Edit::Selector.new(comparators: [comparator])
    end
  end

  def comparators
    Activity.during(video_upload.video.start_at,
                    video_upload.video.end_at).map do |activity|
      video_upload.setups.map do |setup|
        Edit::Comparators::SegmentComparator.new(activity: activity,
                                                 setup: setup)
      end
    end.flatten
  end
end
