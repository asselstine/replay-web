require 'rails_helper'

RSpec.describe Geo do
  describe '#distance_strength' do
    let(:range_m) { 16 }

    subject { Geo.distance_strength(coords1, coords2, range_m) }

    context 'when coords match' do
      let(:coords1) { [0, 0] }
      let(:coords2) { [0, 0] }
      it 'should have a strength of 1' do
        expect(subject).to eq(1)
      end
    end
    context 'when coords are distant' do
      let(:coords1) { [0, 0] }
      let(:coords2) { [90, 180] }
      it 'should have a strength of 0' do
        expect(subject).to eq(0)
      end
    end
    context 'when at the edge of the range' do
      let(:coords1) { double }
      let(:coords2) { double }
      it 'should have a strength of the bell curve at 1' do
        expect(Geocoder::Calculations).to receive(:distance_between)
          .and_return(range_m / 1000.0)
        expect(subject).to be_within(0.01).of(Geo.bell(1))
      end
    end
    context 'when just past the range of the camera' do
      let(:coords1) { double }
      let(:coords2) { double }
      it 'should have a strength of zero' do
        expect(Geocoder::Calculations).to receive(:distance_between)
          .and_return(range_m + 4 / 1000.0)
        expect(subject).to eq(0)
      end
    end
  end
end
