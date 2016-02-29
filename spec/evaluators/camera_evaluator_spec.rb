require 'rails_helper'

RSpec.describe CameraEvaluator do
  let(:camera) { Camera.new }
  let(:context) { Frame.new }
  subject { CameraEvaluator.new(context: context, camera: camera) }

  describe '#coords_at' do
    it 'should find the static coords for the user_locations' do
      locs = double
      expect(subject).to receive(:camera_locations).and_return(locs)
      expect(locs).to receive(:before).with(t(0)).and_return([double])
      subject.coords_at(t(0))
    end
  end

  describe '#coords' do
    it 'should use the context time' do
      expect(context).to receive(:cut_start_at).and_return(t(1))
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
    end
  end
end
