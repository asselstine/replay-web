# rubocop:disable Style/ClassAndModuleChildren
class Edit::ActivityPhotoProcessor
  include Virtus.model
  include Service

  attribute :activity

  def call
    ActiveRecord::Base.transaction do
      Edit::PhotoProcessor.call(selector: selector,
                                start_at: activity.start_at,
                                end_at: activity.end_at)
                          .each(&:save!)
    end
  end

  protected

  def selector
    setups = Setup.with_photos_during(activity.start_at, activity.end_at)
    comparators = setups.map do |setup|
      Edit::PhotoComparator.new(setup: setup, activity: activity)
    end
    Edit::Selector.new(comparators: comparators)
  end
end
