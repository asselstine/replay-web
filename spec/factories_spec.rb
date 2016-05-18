require 'rails_helper'

describe 'Factories' do
  it { expect(create(:user)).to be_valid }
  it { expect(create(:photo_upload)).to be_valid }
  it { expect(create(:activity)).to be_valid }
  it { expect(create(:video_upload)).to be_valid }
  it { expect(create(:video)).to be_valid }
  it { expect(create(:setup)).to be_valid }
end
