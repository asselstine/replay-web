require 'spec_helper'

RSpec.describe Edit::SegmentEffortSelectors do
  let(:start_at) { t(0) }
  let(:end_at) { t(10) }
  let(:activity) { Activity.new }
  let(:segment_effort) do
    SegmentEffort.new(activity: activity,
                      start_at: start_at,
                      end_at: end_at)
  end

  subject do
    Edit::SegmentEffortSelectors.new(segment_effort: segment_effort)
  end

  it 'should find the Setups, create comparators for each' do
    expect(Setup).to receive(:with_videos_during)
      .with(start_at, end_at).and_return([:setup])
    expect(Edit::Comparators::SegmentComparator).to receive(:new)
      .with(activity: activity, setup: :setup).and_return(:comparator)
    expect(Edit::Selector).to receive(:new)
      .with(comparators: [:comparator]).and_return(:selector)
    expect(subject.call).to eq([:selector])
  end
end
