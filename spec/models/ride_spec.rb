require 'rails_helper'

describe Ride do
  let(:locations) { [] }
  subject { create(:ride, locations: locations) }

  context do
    let(:locations) do
      [
        create(:location, timestamp: t(-10)), 
        create(:location, timestamp: t(-3))
      ] 
    end
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
