require 'rails_helper'

describe Api::LocationSamplesController do

  describe '#create' do

    it 'should create a new location' do

      expect {
        post :create, {
            :format => :json,
            :location_sample => {
                :latitude => 32.2,
                :longitude => 127.3,
                :timestamp => '2014'
            }
        }
      }.to change { LocationSample.count }.by(1)

    end

  end

end