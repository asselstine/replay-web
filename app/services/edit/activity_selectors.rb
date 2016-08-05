module Edit
  class ActivitySelectors
    include Virtus.model
    include Service

    attribute :activity

    def call
      comparators.map do |comparator|
        Edit::Selector.new(comparators: [comparator])
      end
    end

    private

    def comparators
      Setup.with_videos_during(activity.start_at,
                               activity.end_at).map do |setup|
        Edit::Comparators::VideoComparator.new(
          activity: activity,
          setup: setup
        )
      end
    end
  end
end
