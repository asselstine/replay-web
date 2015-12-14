require 'rails_helper'

RSpec.describe Camera do
  
  describe '#strength' do
    subject { create(:camera) } 

     
  end

  describe 'class' do
    subject { Camera }

    let(:camera) { create(:camera) } 
    let(:start_at) { t(0) }
    let(:end_at) { t(2) }
    let!(:video) { create(:video,  camera: camera, start_at: start_at, end_at: end_at) }

    describe '#with_video_during' do

      def et(s1,e1)
        expect(subject.with_video_during(t(s1),t(e1)))
      end

      it { et(-1,0).not_to include(camera) }
      it { et(0,1).to include(camera) }
      it { et(0,2).to include(camera) }
      it { et(1,3).to include(camera) }
      it { et(2,3).not_to include(camera) }
    end

    describe '#find_video_candidates' do

      let!(:camera2) { create(:camera) }
      let!(:location) { create(:location, trackable: camera2, timestamp: t(0)) }
      let!(:video) { create(:video, camera: camera2, start_at: start_at, end_at: end_at) }

      def e_nd(location, s1,e1)
        expect(subject.find_video_candidates(location, t(s1),t(e1)))
      end

      it 'should work' do
        e_nd(location, 0, 1).not_to include(camera)
        e_nd(location, 0, 1).to include(camera2)
      end
    end
    describe '#sort_by_strength' do
      it 'should put the strongest cameras first' do
        u = double(User)
        t = double(DateTime)
        c1 = double(Camera)
        c2 = double(Camera)
        expect(c1).to receive(:strength).with(t, u).and_return 1
        expect(c2).to receive(:strength).with(t, u).and_return 2
        expect(Camera.sort_by_strength([c1,c2], t, u).first).to be c2
      end
    end
  end

end
