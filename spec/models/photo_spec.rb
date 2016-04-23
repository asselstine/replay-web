require 'rails_helper'

describe Photo do
  let(:user) { build(:user) }
  let(:camera) { build(:camera) }
  subject { build(:photo, camera: camera, user: user) }

  describe 'class' do
    subject { Photo }
    describe '#during' do
      let!(:photo_lt)        { create(:photo, timestamp: t(-1)) }
      let!(:photo_eq_start)  { create(:photo, timestamp: t(0)) }
      let!(:photo_between)   { create(:photo, timestamp: t(1)) }
      let!(:photo_eq_end)    { create(:photo, timestamp: t(2)) }
      let!(:photo_gt)        { create(:photo, timestamp: t(3)) }
      it do
        photos = subject.during(t(0), t(2))
        expect(photos).to_not include(photo_lt)
        expect(photos).to include(photo_eq_start)
        expect(photos).to include(photo_between)
        expect(photos).to include(photo_eq_end)
        expect(photos).to_not include(photo_gt)
      end
    end
  end
end
