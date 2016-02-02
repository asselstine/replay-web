require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  let(:user) { create(:user) }
  let!(:ride) do
    r = create(:ride, user: user)
    m = (1.0 / 11_120.0)
    t = DateTime.now
    r.locations = Array.new(10) do |i|
      create(:location,
             trackable: r,
             latitude: -49 + i * m, longitude: 128 + i * m,
             timestamp: t.since(i.seconds))
    end
    r
  end

  let!(:video) do
    loc = ride.locations[3]
    vid = create(:video, start_at: ride.start_at, end_at: ride.end_at)
    vid.camera.locations = [create(:location,
                                   trackable: vid.camera,
                                   latitude: loc.latitude,
                                   longitude: loc.longitude,
                                   timestamp: loc.timestamp)]
    expect(vid).to be_valid
    vid
  end

  before(:each) do
    sign_in(user)
  end

  describe '#show' do
    it 'should work' do
      expect do
        get :show
      end.to change { Edit.count }.by(1)
      expect(assigns(:edits)).to_not be_empty
    end
  end
end
