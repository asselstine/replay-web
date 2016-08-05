# Creates VideoDrafts from setups and activities during the time span
class PhotoDrafter
  include Service
  include Virtus.model

  attribute :start_at
  attribute :end_at

  # Optional
  attribute :setups
  attribute :activities

  def call
    processor = photo_processor
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
      processor.drafts.each(&:save)
    end
    processor.drafts
  end

  private

  def photo_processor
    Edit::FrameProcessors::PhotoProcessor.new
  end

  def activities
    @activities ||= Activity.during(start_at, end_at)
  end

  def setups
    @setups ||= Setup.with_photos_during(start_at, end_at)
  end

  def selectors
    activities.map do |activity|
      setups.map do |setup|
        Edit::Selector.new(
          comparators: [
            Edit::Comparators::PhotoComparator.new(setup: setup,
                                                   activity: activity)
          ]
        )
      end
    end.flatten
  end
end
