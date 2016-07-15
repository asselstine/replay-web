require 'rails_helper'

RSpec.describe Activity do
  subject do
    create(:activity,
           timestamps: [t(-10), t(-3)],
           latitudes: [0, 1],
           longitudes: [2, 3])
  end

  context do
    describe '#start_at' do
      it 'should return the minimum location timestamp' do
        expect(subject.start_at).to eq(t(-10))
      end
    end
    describe '#end_at' do
      it 'should return the maximum location timestamp' do
        expect(subject.end_at).to eq(t(-3))
      end
    end
    describe '#timeseries_index_at' do
      it 'should return 0 when before the range' do
        expect(subject.timeseries_index_at(t(-11))).to eq(0)
      end

      it 'should return nil when after the range' do
        expect(subject.timeseries_index_at(t(4))).to be_nil
      end

      it 'should return the index of the timestamp' do
        expect(subject.timeseries_index_at(t(-10))).to eq(0)
        expect(subject.timeseries_index_at(t(-3))).to eq(1)
      end
    end
  end
end
