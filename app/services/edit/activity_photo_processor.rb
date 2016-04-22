class Edit::ActivityPhotoProcessor
  include Virtus.model
  include Service

  attribute :activity

  def call
    Edit::PhotoProcessor.call(selector: selector,
                              start_at: activity.start_at,
                              end_at: activity.end_at)
  end

  protected

  def selector
    setups = Setup.with_photos_during(activity.start_at, activity.end_at)
    comparators = setups.map do |setup|
      Edit::PhotoComparator.new(setup: setup, activity: activity)
    end
    Selector.new(comparators: comparators)
  end
end
