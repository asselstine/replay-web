require 'spec_helper'

RSpec.describe Edit::FrameProcessors::VideoProcessor do
  let(:selector) { Edit::Selector.new }
  let(:frame) { Frame.new }
  let(:video) { Video.new }
  let(:video_upload) { VideoUpload.new(video: video) }
  let(:activity) { Activity.new(strava_name: 'strava') }
  let(:setup) { Setup.new }
  let(:comparator) do
    Edit::Comparators::VideoComparator.new(video: video,
                                           setup: setup,
                                           activity: activity)
  end

  subject do
    Edit::FrameProcessors::VideoProcessor.new(selector: selector)
  end

  describe '#process' do
    context 'with a video that smaller than the frame' do
      let(:video) { Video.new(start_at: t(1), end_at: t(2)) }

      it 'should create a draft of the video size' do
        expect(selector).to receive(:select)
          .with(f(0, 5))
          .and_return(comparator)
        expect(VideoDraft).to receive(:new)
          .with(activity: activity,
                setup: setup,
                source_video: video,
                start_at: t(1),
                end_at: t(2),
                name: 'strava')
        subject.process(f(0, 5))
      end
    end

    context 'with a video that exceeds the frame size' do
      let(:video) { Video.new(start_at: t(3), end_at: t(9)) }

      it 'should create a video draft with max size' do
        expect(selector).to receive(:select)
          .with(f(0, 5))
          .and_return(comparator)
        expect(VideoDraft).to receive(:new)
          .with(activity: activity,
                setup: setup,
                source_video: video,
                start_at: t(3),
                end_at: t(5),
                name: 'strava')
        expect(subject.process(f(0, 5))).to eq(t(5))
      end
    end

    context 'with a video that is larger than the frame' do
      let(:video) { Video.new(start_at: t(3), end_at: t(9)) }
      let(:video_draft) do
        VideoDraft.new(
          source_video: video,
          end_at: t(5)
        )
      end

      it 'should extend the draft across the frames' do
        expect(selector).to receive(:select)
          .with(f(0, 5))
          .and_return(comparator)
        expect(selector).to receive(:select)
          .with(f(5, 10))
          .and_return(comparator)
        expect(VideoDraft).to receive(:new)
          .with(activity: activity,
                setup: setup,
                source_video: video,
                start_at: t(3),
                end_at: t(5),
                name: 'strava')
          .and_return(video_draft)
        expect(subject.process(f(0, 5))).to eq(t(5))
        expect(video_draft).to receive(:end_at=).with(t(9))
        expect(subject.process(f(5, 10))).to eq(t(9))
      end
    end
  end
end
