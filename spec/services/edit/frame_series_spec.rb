require 'spec_helper'

RSpec.describe Edit::FrameSeries do
  let(:processor) { double }
  let(:start_at) { t(0) }
  let(:end_at) { t(2) }
  let(:frame_size) { 1.second }

  subject do
    Edit::FrameSeries.new(processor: processor,
                          start_at: start_at,
                          end_at: end_at,
                          frame_size: frame_size)
  end

  context 'when the frame size is 1 and the end is not overridden' do
    let(:frame_size) { 1.second }

    it 'should execute the frames in order' do
      expect(processor).to receive(:process).with(f(0, 1))
      expect(processor).to receive(:process).with(f(1, 2))
      subject.call
    end
  end

  context 'when the end is not on a frame boundary' do
    let(:start_at) { t(0) }
    let(:end_at) { t(1.5) }
    let(:frame_size) { 1.second }

    it 'should only go so far as the end' do
      expect(processor).to receive(:process).with(f(0, 1))
      expect(processor).to receive(:process).with(f(1, 1.5))
      subject.call
    end

    context 'and the start is fractional' do
      let(:start_at) { t(0.4) }

      it 'should iterate by the frame size' do
        expect(processor).to receive(:process).with(f(0.4, 1.4))
        expect(processor).to receive(:process).with(f(1.4, 1.5))
        subject.call
      end
    end
  end

  context 'when the processor overrides the frame end' do
    let(:start_at) { t(0) }
    let(:end_at) { t(2) }

    it 'should use the overridden value' do
      expect(processor).to receive(:process)
        .with(f(0, 1)).and_return(t(0.8))
      expect(processor).to receive(:process)
        .with(f(0.8, 1.8)).and_return(t(1.2))
      expect(processor).to receive(:process)
        .with(f(1.2, 2))
      subject.call
    end
  end
end
