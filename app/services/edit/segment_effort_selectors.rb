module Edit
  class SegmentEffortSelectors
    include Virtus.model
    include Service

    attribute :segment_effort

    def call
      comparators.map do |comparator|
        Edit::Selector.new(comparators: [comparator])
      end
    end

    private

    def comparators
      Setup.with_videos_during(segment_effort.start_at,
                               segment_effort.end_at).map do |setup|
        Edit::Comparators::SegmentComparator.new(
          activity: segment_effort.activity,
          setup: setup
        )
      end
    end
  end
end
