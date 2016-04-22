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

  it 'location factory' do
    expect( create(:location).valid? ).to be_truthy
  end

  it 'activity factory' do
    expect( create(:activity).valid? ).to be_truthy
  end

  it 'camera factory' do
    expect( create(:camera).valid? ).to be_truthy
  end


end
