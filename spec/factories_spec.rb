require 'rails_helper'

describe 'Factories' do

  it 'user factory' do
    expect( create(:user).valid? ).to be_truthy
  end
  #
  # it 'dropbox_photo factory' do
  #   expect( create(:dropbox_photo).valid? ).to be_truthy
  # end
  #
  # it 'dropbox_event factory' do
  #   expect( create(:dropbox_event).valid? ).to be_truthy
  # end

  it 'photo factory' do
    expect( create(:photo).valid? ).to be_truthy
  end

  it 'location_sample factory' do
    expect( create(:location_sample).valid? ).to be_truthy
  end

  it 'ride factory' do
    expect( create(:ride).valid? ).to be_truthy
  end


end