class ActivityVideos
  include Virtus.model
  include Service

  attribute :activity, Activity

  def call
    processor = video_processor
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        processor.selector = selector
        Edit::FrameSeries.call(
          processor: processor,
          start_at: activity.start_at,
          end_at: activity.end_at
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
    Edit::ActivityVideoStrategy.new
  end

  def selectors
    Edit::ActivitySelectors.call(activity: activity)
  end
end
