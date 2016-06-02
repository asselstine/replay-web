require 'rails_helper'

RSpec.describe Setup do
  describe 'class' do
    subject { Setup }

    describe '#with_videos_during' do
      let(:start_at) { t(0) }
      let(:end_at) { t(2) }
      let(:setup) { create(:setup) }
      let(:video) { create(:video, start_at: start_at, end_at: end_at) }
      let!(:upload) do
        create(:video_upload, setups: [setup],
                              video: video)
      end

      def et(s1, e1)
        expect(subject.with_videos_during(t(s1), t(e1)))
      end

      it { et(-1, 0).not_to include(setup) }
      it { et(0, 1).to include(setup) }
      it { et(0, 2).to include(setup) }
      it { et(1, 3).to include(setup) }
      it { et(2, 3).not_to include(setup) }
    end
  end
end
