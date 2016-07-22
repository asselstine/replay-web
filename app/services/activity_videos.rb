class ActivityVideos
  include Virtus.model
  include Service

  attribute :activity

  def call
    ActiveRecord::Base.transaction do
      Edit::VideoProcessor.call(selector: selector,
                                start_at: activity.start_at,
                                end_at: activity.end_at)
                          .each(&:save!)
    end
  end

  private

  def selector
    setups = Setup.with_videos_during(activity.start_at, activity.end_at)
    comparators = setups.map do |setup|
      Edit::VideoComparator.new(setup: setup, activity: activity)
    end
    Edit::Selector.new(comparators: comparators)
  end
end
