require 'spec_helper'

RSpec.describe SegmentEffortVideos do
  let(:activity) { Activity.new }
  let(:segment_effort) do
    SegmentEffort.new(activity: activity,
                      start_at: t(0),
                      end_at: t(10))
  end
  let(:video_draft) { double }
  let(:video_processor) { double(video_drafts: [video_draft]) }
  let(:segment_effort_strategy) do
    Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy
  end

  subject do
    SegmentEffortVideos.new(
      segment_effort: segment_effort
    )
  end

  it 'should call the frame series for each selector' do
    expect(Edit::FrameProcessors::VideoProcessor).to receive(:new)
      .with(video_drafting_strategy: an_instance_of(segment_effort_strategy))
      .and_return(video_processor)
    expect(Edit::SegmentEffortSelectors).to receive(:call)
      .with(segment_effort: segment_effort)
      .and_return([:selector])
    expect(video_processor).to receive(:selector=).with(:selector)
    expect(Edit::FrameSeries).to receive(:call)
      .with(processor: video_processor,
            start_at: t(0),
            end_at: t(10))
    expect(video_draft).to receive(:save)
    subject.call
  end
end
