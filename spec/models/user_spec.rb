require 'rails_helper'

describe User do

  let(:user) { create(:user) }

  context 'whose been on a ride' do

    let(:ride) { create(:ride, user: user) }
    let!(:location) { create(:location, trackable: ride) }

    let(:camera) { create(:camera) } 
    let!(:photo) do
      create(:photo, camera: camera, timestamp: location.timestamp)
    end

    context 'and didnt have photos taken' do

      let!(:camera_location) do
        create(:location, 
               trackable: camera, 
               timestamp: location.timestamp,
               latitude: location.latitude, 
               longitude: -location.longitude)
      end

      describe '#photos' do
        subject { user.feed_photos } 
        it 'should have no photos' do
          expect(user.feed_photos).not_to include(photo)
        end
      end

    end

    context 'and had photos taken' do

      let!(:camera_location) do
        create(:location, 
               trackable: camera, 
               timestamp: location.timestamp,
               latitude: location.latitude, 
               longitude: location.longitude)
      end

      describe '#photos' do
        it 'should return all the photos' do
          expect(user.feed_photos).to include(photo)
        end
      end
    end
  end
end
