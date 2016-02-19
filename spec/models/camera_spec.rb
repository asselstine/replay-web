require 'rails_helper'

RSpec.describe Camera do
  subject { create(:camera) }
  describe 'class' do
    subject { Camera }

    let(:camera) { create(:camera) }
    let(:start_at) { t(0) }
    let(:end_at) { t(2) }
    let!(:video) do
      create(:video, camera: camera, start_at: start_at, end_at: end_at)
    end

    describe '#with_video_during' do
      def et(s1, e1)
        expect(subject.with_video_during(t(s1), t(e1)))
      end

      it { et(-1, 0).not_to include(camera) }
      it { et(0, 1).to include(camera) }
      it { et(0, 2).to include(camera) }
      it { et(1, 3).to include(camera) }
      it { et(2, 3).not_to include(camera) }
    end
  end
end
