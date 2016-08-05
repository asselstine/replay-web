require 'rails_helper'

RSpec.describe Edit::ActivitySelectors do
  let(:start_at) { t(0) }
  let(:end_at) { t(10) }
  let(:activity) do
    Activity.new(start_at: start_at,
                 end_at: end_at)
  end

  subject do
    Edit::ActivitySelectors.new(activity: activity)
  end

  it 'should find the Setups, create comparators for each' do
    expect(Setup).to receive(:with_videos_during)
      .with(start_at, end_at).and_return([:setup])
    expect(Edit::Comparators::VideoComparator).to receive(:new)
      .with(activity: activity, setup: :setup).and_return(:comparator)
    expect(Edit::Selector).to receive(:new)
      .with(comparators: [:comparator]).and_return(:selector)
    expect(subject.call).to eq([:selector])
  end
end
