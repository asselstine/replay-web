require 'rails_helper'

describe Location do

  describe 'class' do
    subject { Location }
    describe '#ballpark' do
      let(:location) { create(:location, timestamp: t(2)) }
      it do
        expect(subject.ballpark_during(location, t(1), t(3)).map(&:id)).to include(location.id)
      end
      it do 
        expect(subject.ballpark_during(location, t(0), t(1)).map(&:id)).to_not include(location.id)
      end
    end

    describe '#interpolate_at' do

      let!(:loc1) { create(:location, timestamp: t(0), latitude: 0, longitude: 0) }
      let!(:loc2) { create(:location, timestamp: t(2), latitude: 2, longitude: 2) }

      context 'when there are enough locations to interpolate' do
        let!(:loc3) { create(:location, timestamp: t(4), latitude: 4, longitude: 4) }
        it 'should interpolate the lat and long' do
          expect(subject.interpolate_at(t(1))).to eq([1,1])
        end

        context 'when you query for a time before the data' do
          it 'should return the first coords' do
            expect(subject.interpolate_at(t(-1))).to eq([0,0])
          end
        end

        context 'when you query for a time on a datapoint' do
          it 'should return the datapoint' do
            expect(subject.interpolate_at(t(0))).to eq([0,0])
          end
        end

        context 'when you query for a time after the dataset' do
          it 'should return the last datapoint' do
            expect(subject.interpolate_at(t(9))).to eq([4,4])
          end
        end
      end

      context 'when too few locations to interpolate' do
        it 'should just return the first location' do
          expect(subject.interpolate_at(t(1))).to eq([0,0])
        end
      end

      context 'when there is a static location' do
        let!(:loc3) { create(:location, timestamp: nil, latitude: 5, longitude: 8) }
        it 'should just return the first static location' do
          expect(subject.interpolate_at(t(1))).to eq([5, 8])
        end
      end
    end
  end
end
