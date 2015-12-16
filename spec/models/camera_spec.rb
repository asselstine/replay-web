require 'rails_helper'

RSpec.describe Camera do
  let(:range_m) { 10 }
  subject { create(:camera, range_m: range_m) } 

  describe '#strength' do
    let(:user) { build(:user) }
    context 'proximity' do
      context 'when coords match' do
        it 'should have a strength of 1' do
          expect(subject).to receive(:coords_at).with(t(0)).and_return([0,0]) 
          expect(user).to receive(:coords_at).with(t(0)).and_return([0,0]) 
          expect(subject.strength(t(0), user)).to eq(1)
        end
      end
      context 'when coords are distant' do
        it 'should have a strength of 0' do
          expect(subject).to receive(:coords_at).with(t(0)).and_return([0,0]) 
          expect(user).to receive(:coords_at).with(t(0)).and_return([90,180]) 
          expect(subject.strength(t(0), user)).to eq(0)
        end
      end
      context 'when at the edge of the range' do
        it 'should have a strength of the bell curve at 1' do
          expect(subject).to receive(:coords_at).with(t(0))
            .and_return(double(Array)) 
          expect(user).to receive(:coords_at).with(t(0))
            .and_return(double(Array)) 
          expect(Geocoder::Calculations).to receive(:distance_between)
            .and_return(10.0/1000.0)
          expect(subject.strength(t(0), user)).to be_within(0.01).of(Camera.bell(1))
        end
      end
    end
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
