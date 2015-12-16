require 'rails_helper'

describe User do

  subject { create(:user) }

  describe '#feed_photos' do
    it 'should scan the timeline of the user' do
      a = double
      b = double
      c = double
      expect(subject).to receive(:feed_start_at).and_return(t(0))
      expect(subject).to receive(:feed_end_at).and_return(t(2))
      expect(subject).to receive(:feed_photos_during).with(t(0),t(1)).and_return([a])
      expect(subject).to receive(:feed_photos_during).with(t(1),t(2)).and_return([b])
      expect(subject).to receive(:feed_photos_during).with(t(2),t(3)).and_return([c])
      expect(subject.feed_photos).to eq([a,b,c])
    end
  end

  describe '#feed_photos_during' do
    it 'should find strong photos taken within the time range' do
      c1 = double(Camera)
      c2_photos = double(Array)
      c2 = double(Camera, photos: c2_photos) 
      expect(Camera).to receive(:all).and_return([c1,c2])
      expect(c1).to receive(:strength).and_return(Camera::MIN_STRENGTH / 2.0)
      expect(c2).to receive(:strength).and_return(Camera::MIN_STRENGTH)
      expect(c2.photos).to receive(:during).with(t(0), t(2)).and_return([1,2,3])
      expect(subject.feed_photos_during(t(0), t(2))).to eq([1,2,3])
    end
  end
end
