# rubocop:disable Style/ClassAndModuleChildren
class Edit::ActivityVideoProcessor
  include Virtus.model
  include Service

  attribute :activity

  def call
    Edit::VideoProcessor.call(selector: selector,
                              start_at: activity.start_at,
                              end_at: activity.end_at).each(&:save!)
  end

  private

  def selector
    setups = Setup.with_uploads_during(activity.start_at, activity.end_at)
    comparators = setups.map do |setup|
      Edit::VideoComparator.new(setup: setup, activity: activity)
    end
    Selector.new(comparators: comparators)
  end
end
