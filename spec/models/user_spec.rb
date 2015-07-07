require 'rails_helper'

describe User do

  let(:user) { create(:user) }

  context 'whose been on a ride' do

    let(:ride) { create(:ride, :user => user) }
    let(:location_samples) { create_list(:location_sample, 10, :ride => ride) }
    let(:event) { create(:dropbox_event) }

    context 'and didnt have photos taken' do

      let(:photos) {
        create_list(:dropbox_photo, 10, :latitude => -location_samples.first.latitude,
                    :longitude => -location_samples.first.longitude,
                    :dropbox_event => event)
      }

      describe '#photos' do
        it 'should have no photos' do
          photos
          expect(user.photos).to be_empty
        end
      end

    end

    context 'and had photos taken' do

      let(:photos) {
        create_list(:dropbox_photo, 10, :latitude => location_samples.first.latitude,
                                        :longitude => location_samples.first.longitude,
                                        :dropbox_event => event)
      }

      describe '#photos' do
        it 'should return all the photos' do
          all = photos
          expect(user.photos).to eq(all)
        end
      end
    end
  end
end