require 'rails_helper'

describe Api::LocationSamplesController do

  describe '#create' do

    let(:user) {
      create(:user)
    }

    subject {
      post :create, {
          :format => :json,
          :location_sample => {
              :latitude => 32.2,
              :longitude => 127.3,
              :timestamp => '2014'
          }
      }
    }

    before(:each) do
      sign_in(user)
    end

    it 'should create a new location' do
      expect {
        subject
      }.to change { LocationSample.count }.by(1)
      expect(LocationSample.last.ride).to_not be_nil
    end

    it 'should create a new ride if one doesnt exist' do
      expect {
        subject
      }.to change { Ride.count }.by(1)
    end

  end

end