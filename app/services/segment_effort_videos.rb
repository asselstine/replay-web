class SegmentEffortVideos
  include Virtus.model
  include Service

  attribute :segment_effort, SegmentEffort

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
    comparators.map do |comparator|
      Edit::Selector.new(comparators: [comparator])
    end
  end

  def comparators
    Setup.with_videos_during(segment_effort.start_at,
                             segment_effort.end_at).map do |setup|
      Edit::Comparators::SegmentComparator.new(activity: activity,
                                               setup: setup)
    end
  end

  def activity
    segment_effort.activity
  end
end
