require 'rails_helper'

describe Ride do
  let(:time_series_data) { [] }
  subject { create(:ride, time_series_data: time_series_data) }

  context do
    let(:time_series_data) do
      create(:time_series_data,
             timestamps: [t(-10), t(-3)],
             latitudes: Array.new(2),
             longitudes: Array.new(2))
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
