require 'rails_helper'

describe Location do
  describe 'class' do
    subject { Location }

    describe '#during' do
      let!(:l_lt)        { create(:location, timestamp: t(0)) }
      let!(:l_eq_start)  { create(:location, timestamp: t(1)) }
      let!(:l_between)   { create(:location, timestamp: t(2)) }
      let!(:l_eq_end)    { create(:location, timestamp: t(3)) }
      let!(:l_gt)        { create(:location, timestamp: t(4)) }

      it 'should return the locations during the passed time' do
        locs = subject.during(t(1),t(3))
        expect(locs).not_to include(l_lt)
        expect(locs).to include(l_eq_start)
        expect(locs).to include(l_between)
        expect(locs).to include(l_eq_end)
        expect(locs).not_to include(l_gt)
      end
    end

    describe '#interpolate_at' do

      let!(:loc2) { create(:location, timestamp: t(2), latitude: 2, longitude: 2) }
      let!(:loc1) { create(:location, timestamp: t(0), latitude: 0, longitude: 0) }

      context 'when there are enough locations to interpolate' do
        let!(:loc3) { create(:location, timestamp: t(4), latitude: 4, longitude: 4) }
        it 'should interpolate the lat and long' do
          expect(subject.interpolate_at(t(1))).to eq([1,1])
        end

        context 'when you query for a time before the data' do
          it 'should return nil' do
            expect(subject.interpolate_at(t(-10))).to eq(nil)
            expect(subject.interpolate_at(t(-1))).to eq(nil)
          end
        end

        context 'when you query for a time on a datapoint' do
          it 'should return the datapoint' do
            expect(subject.interpolate_at(t(0))).to eq([0,0])
          end
        end

        context 'when you query for a time after the dataset' do
          it 'should return nil' do
            expect(subject.interpolate_at(t(5))).to eq(nil)
            expect(subject.interpolate_at(t(10))).to eq(nil)
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
