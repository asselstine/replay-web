require 'rails_helper'

RSpec.describe VideoSegmentEfforts do
  let(:video) do
    Video.new(start_at: t(0),
              end_at: t(10))
  end
  let(:setup) { Setup.new }
  let(:video_upload) do
    VideoUpload.new(video: video,
                    setups: [setup])
  end
  let(:video_draft) { double }
  let(:video_processor) { double(video_drafts: [video_draft]) }
  let(:segment_effort_strategy) do
    Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy
  end

  subject do
    VideoSegmentEfforts.new(
      video_upload: video_upload
    )
  end

  it 'should call the frame series for each selector' do
    expect(Edit::FrameProcessors::VideoProcessor).to receive(:new)
      .with(video_drafting_strategy: an_instance_of(segment_effort_strategy))
      .and_return(video_processor)
    expect(Edit::VideoUploadSelectors).to receive(:call)
      .with(video_upload: video_upload)
      .and_return([:selector])
    expect(video_processor).to receive(:selector=).with(:selector)
    expect(Edit::FrameSeries).to receive(:call)
      .with(processor: video_processor,
            start_at: t(0),
            end_at: t(10))
    expect(video_draft).to receive(:save!)
    subject.call
  end
end
