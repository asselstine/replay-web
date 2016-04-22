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
  end
end
