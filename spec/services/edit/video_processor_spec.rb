require 'rails_helper'

RSpec.describe Edit::VideoProcessor do
  let(:selector) { Edit::Selector.new }
  let(:start_at) { t(0) }
  let(:end_at) { t(10) }
  let(:frame_size) { 5.seconds }
  let(:video_upload) { VideoUpload.new(video: video) }
  let(:comparator) { double(video: video, setup: nil, activity: nil) }
  subject do
    Edit::VideoProcessor.new(selector: selector,
                             start_at: start_at,
                             end_at: end_at,
                             frame_size: frame_size)
  end

  context 'with a video that smaller than the frame' do
    let(:video) { Video.new(start_at: t(1), end_at: t(2)) }

    it 'should create a draft that matches the video' do
      expect_frame t(0), t(5), comparator
      expect_frame t(2), t(7)
      expect_frame t(7), t(12)
      expect_first_draft_includes(subject.call, start_at: t(1),
                                                end_at: t(2))
    end
  end

  context 'with a video that is larger than the frame' do
    let(:video) { Video.new(start_at: t(3), end_at: t(9)) }

    it 'should create a draft of the video' do
      expect_frame t(0), t(5), comparator
      expect_frame t(5), t(10), comparator
      expect_frame t(9), t(14)
      expect_first_draft_includes(subject.call, start_at: t(3),
                                                end_at: t(9))
    end
  end

  context 'with a video that exceeds the total size' do
    let(:video) { Video.new(start_at: t(-1), end_at: t(11)) }

    it 'should create a draft of the maximum size' do
      expect_frame t(0), t(5), comparator
      expect_frame t(5), t(10), comparator
      expect_first_draft_includes(subject.call, start_at: t(0),
                                                end_at: t(10))
    end
  end

  def expect_first_draft_includes(drafts, **attributes)
    expect(drafts.length).to eq(1)
    expect(drafts.first.attributes.symbolize_keys)
      .to include(attributes.symbolize_keys)
  end

  def expect_frame(start_at, end_at, comparator = nil)
    expect(selector).to receive(:find_best)
      .with(Edit::Frame.new(start_at: start_at,
                            end_at: end_at)).and_return(comparator)
  end
end
