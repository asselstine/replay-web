require 'rails_helper'

describe EditEvaluator do
  let(:video) { double }
  let(:video_evaluator) { double(video: video) }
  let(:video_evaluators) { [video_evaluator] }
  let(:user_evaluator) { double }
  let(:frame) { Frame.new(start_at: t(0), end_at: t(10)) }

  subject do
    eval = EditEvaluator.new(user_evaluator: user_evaluator, frame: frame)
    expect(eval).to receive(:video_evaluators).and_return(video_evaluators)
    eval
  end

  it 'should return nothing if there is no strong video' do
    expect(video_evaluator).to receive(:strength)
      .with(user_evaluator).and_return(0)
    expect(subject.find_best_video).to be_nil
  end

  it 'should return a video if it has strength' do
    expect(video_evaluator).to receive(:strength)
      .with(user_evaluator).and_return(0.1)
    expect(subject.find_best_video).to eq(video)
  end

  context 'with multiple videos' do
    let(:video2) { double }
    let(:video2_evaluator) { double(video: video2) }
    let(:video_evaluators) { [video2_evaluator, video_evaluator] }

    it 'should return the strongest video' do
      expect(video2_evaluator).to receive(:strength)
        .with(user_evaluator).and_return(0.34)
      expect(video_evaluator).to receive(:strength)
        .with(user_evaluator).and_return(0.5)
      expect(subject.find_best_video).to eq(video)
    end
  end
end
