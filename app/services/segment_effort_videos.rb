class SegmentEffortVideos
  include Virtus.model
  include Service

  attribute :segment_effort, SegmentEffort

  def call
    processor = video_processor
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        processor.selector = selector
        Edit::FrameSeries.call(
          processor: processor,
          start_at: segment_effort.start_at,
          end_at: segment_effort.end_at
        )
      end
      processor.video_drafts.each(&:save)
    end
    processor.video_drafts
  end

  def video_processor
    Edit::FrameProcessors::VideoProcessor.new(
      video_drafting_strategy: strategy
    )
  end

  def strategy
    Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy.new
  end

  def selectors
    Edit::SegmentEffortSelectors.call(segment_effort: segment_effort)
  end
end
