require 'spec_helper'

RSpec.describe Edit::VideoUploadSelectors do
  let(:start_at) { t(0) }
  let(:end_at) { t(10) }
  let(:video) do
    Video.new(start_at: start_at,
              end_at: end_at)
  end
  let(:setup) { Setup.new }
  let(:video_upload) do
    VideoUpload.new(video: video, setups: [setup])
  end

  subject do
    Edit::VideoUploadSelectors.new(video_upload: video_upload)
  end

  it 'should find the Setups, create comparators for each' do
    expect(Activity).to receive(:during)
      .with(start_at, end_at).and_return([:activity])
    expect(Edit::Comparators::SegmentComparator).to receive(:new)
      .with(activity: :activity, setup: setup).and_return(:comparator)
    expect(Edit::Selector).to receive(:new)
      .with(comparators: [:comparator]).and_return(:selector)
    expect(subject.call).to eq([:selector])
  end
end
