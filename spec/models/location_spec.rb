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
        locs = subject.during(t(1), t(3))
        expect(locs).not_to include(l_lt)
        expect(locs).to include(l_eq_start)
        expect(locs).to include(l_between)
        expect(locs).to include(l_eq_end)
        expect(locs).not_to include(l_gt)
      end
    end

    describe '#can_interpolate?' do
      let(:l1) { create(:location, timestamp: t(1)) }
      let(:l2) { create(:location, timestamp: t(3)) }
      let!(:locations) { [ l1, l2 ] }

      describe 'when there are not enough samples' do
        it { expect(subject.can_interpolate?(t(0), locations)).to be_falsey }
      end

      context 'when there are enough samples' do
        let(:l3) { create(:location, timestamp: t(5)) }
        let!(:locations) { [ l1, l2, l3] }
        it 'should allow interpolation' do
          expect(subject.can_interpolate?(t(1), locations)).to be_truthy
        end
        it 'should disallow if time is before samples' do
          expect(subject.can_interpolate?(t(-1), locations)).to be_falsey
        end
        it 'should disallow if time is after samples' do
          expect(subject.can_interpolate?(t(9), locations)).to be_falsey
        end
      end
    end

    describe '#to_time_ms' do
      it 'should cast a datetime to milliseconds' do
        expect(subject.to_time_ms(DateTime.parse('Sat, 26 Dec 2015 13:46:49 -0800'))).to eq(1451166409000)
      end
    end

    describe '#before' do
      let(:l1) { create(:location, timestamp: t(0)) }
      let(:l2) { create(:location, timestamp: t(1)) }
      let(:l3) { create(:location, timestamp: t(2)) }
      let!(:locations) { [l1, l2, l3] }
      it 'should return all locations before the time' do
        expect(subject.before(t(1))).to include(l1)
        expect(subject.before(t(1))).to include(l2)
        expect(subject.before(t(1))).not_to include(l3)
      end
    end
  end
end
