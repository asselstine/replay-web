require 'rails_helper'

RSpec.describe VideoUpload do
  let(:now) { DateTime.now }
  def time(seconds)
    now.since(seconds)
  end

  context 'class' do
    subject { VideoUpload }

    describe '#during' do
      let(:start_at) { time(0) }
      let(:end_at) { time(5) }
      let(:video) { create(:video, start_at: start_at, end_at: end_at) }
      let(:video_upload) { create(:video_upload, video: video) }

      def during(start_at, end_at)
        expect(subject.during(start_at, end_at))
      end

      context 'upload is within the tick' do
        it { during(time(-1), time(0)).to_not include(video_upload) }
        it { during(time(-1), time(1)).to include(video_upload) }
        it { during(time(0), time(1)).to include(video_upload) }
        it { during(time(2), time(3)).to include(video_upload) }
        it { during(time(5), time(6)).to_not include(video_upload) }
      end
    end
  end
end
