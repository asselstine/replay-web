require 'rails_helper'

describe User do

  subject { create(:user) }

  describe '#feed_photos' do
    it 'should scan the timeline of the user' do
      a = double
      b = double
      allow(subject).to receive(:feed_start_at).and_return(t(0))
      allow(subject).to receive(:feed_end_at).and_return(t(2))
      expect(subject).to receive(:feed_photos_during).and_return([a])
      expect(subject).to receive(:feed_photos_during).and_return([b])
      expect(subject.feed_photos).to eq([a,b])
    end
  end

  describe '#feed_photos_during' do
    it 'should find strong photos taken within the time range' do
      c1 = double(Camera)
      c1_eval = double(CameraEvaluator)
      c2 = double(Camera, photos: double(Array)) 
      c2_eval = double(CameraEvaluator)
      edit_context = Frame.new(start_at: t(0), end_at: t(1))

      expect(Camera).to receive(:all).and_return([c1,c2])

      expect(c1).to receive(:evaluator).with(edit_context)
        .and_return(c1_eval)
      expect(c1_eval).to receive(:strength).with(kind_of(UserEvaluator))
        .and_return(Camera::MIN_STRENGTH / 2.0)
      expect(c2).to receive(:evaluator).with(edit_context)
        .and_return(c2_eval)
      expect(c2_eval).to receive(:strength).with(kind_of(UserEvaluator))
        .and_return(Camera::MIN_STRENGTH)
      expect(c2.photos).to receive(:during).with(t(0), t(1))
        .and_return([1,2,3])
      expect(subject).to receive(:evaluator).with(edit_context)
        .and_return(UserEvaluator.new)
      expect(subject.feed_photos_during(edit_context)).to eq([1,2,3])
    end
  end
end
