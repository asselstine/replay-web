require 'rails_helper'

describe '/api' do

  describe '/location_samples' do

    describe 'POST' do

      it 'should create a new location sample' do

        expect {
          post '/api/location_samples', {
              :location_sample => {
                  :latitude => 1.2,
                  :longitude => 1.3,
                  :timestamp => '2014'
              }
          }
        }.to change { LocationSample.count }.by(1)

      end

    end

  end

end