require 'rails_helper'

RSpec.describe CameraEvaluator do
  let(:time_series_data) { double }
  let(:camera) { Camera.new }
  let(:frame) { Frame.new }
  subject { CameraEvaluator.new(frame: frame, camera: camera) }

  describe '#coords_at' do
    it 'should use the time series to return the location' do
      coords = double
      expect(camera).to receive(:time_series_data).and_return(time_series_data)
      expect(time_series_data).to receive(:coords_at)
        .with(t(0)).and_return(coords)
      expect(subject.coords_at(t(0))).to eq coords
    end
  end

  describe '#coords' do
    it 'should use the frame time' do
      expect(frame).to receive(:start_at).and_return(t(1))
      expect(subject).to receive(:coords_at).with(t(1))
      subject.coords
    end
  end

  describe '#strength' do
    let(:user_evaluator) { double(UserEvaluator) }
    context 'proximity' do
      context 'when coords match' do
        it 'should have a strength of 1' do
          expect(subject).to receive(:coords).and_return([0, 0])
          expect(user_evaluator).to receive(:coords).and_return([0, 0])
          expect(subject.strength(user_evaluator)).to eq(1)
        end
      end
      context 'when coords are distant' do
        it 'should have a strength of 0' do
          expect(subject).to receive(:coords).and_return([0, 0])
          expect(user_evaluator).to receive(:coords).and_return([90, 180])
          expect(subject.strength(user_evaluator)).to eq(0)
        end
      end
      context 'when at the edge of the range' do
        it 'should have a strength of the bell curve at 1' do
          expect(subject).to receive(:coords).and_return(double(Array))
          expect(user_evaluator).to receive(:coords).and_return(double(Array))
          expect(Geocoder::Calculations).to receive(:distance_between)
            .and_return(10.0 / 1000.0)
          expect(subject.strength(user_evaluator))
            .to be_within(0.01).of(Camera.bell(1))
        end
      end
      context 'when just past the range of the camera' do
        it 'should have a strength of zero' do
          expect(subject).to receive(:coords).and_return(double(Array))
          expect(user_evaluator).to receive(:coords).and_return(double(Array))
          expect(Geocoder::Calculations).to receive(:distance_between)
            .and_return(12.0 / 1000.0)
          expect(subject.strength(user_evaluator)).to eq(0)
        end
      end
    end
  end
end
