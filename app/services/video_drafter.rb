# Creates VideoDrafts from setups and activities during the time span
class VideoDrafter
  include Service
  include Virtus.model

  attribute :start_at
  attribute :end_at

  # Optional
  attribute :setups
  attribute :activities

  def call
    processor = video_processor
    ActiveRecord::Base.transaction do
      # gather all the activities during the video upload
      selectors.each do |selector|
        processor.selector = selector
        Edit::FrameSeries.call(
          processor: processor,
          start_at: start_at,
          end_at: end_at
        )
      end
      processor.video_drafts.each(&:save)
    end
    processor.video_drafts
  end

  def video_processor
    Edit::FrameProcessors::VideoProcessor.new(
      video_drafting_strategy: Edit::ActivityVideoStrategy.new
    )
  end

  def activities
    @activities ||= Activity.during(start_at, end_at)
  end

  def setups
    @setups ||= Setup.with_videos_during(start_at, end_at)
  end

  def selectors
    activities.map do |activity|
      setups.map do |setup|
        Edit::Selector.new(
          comparators: [
            Edit::Comparators::VideoComparator.new(
              setup: setup,
              activity: activity,
              cache_start_at: activity.start_at,
              cache_end_at: activity.end_at
            )
          ]
        )
      end
    end.flatten
  end
end
