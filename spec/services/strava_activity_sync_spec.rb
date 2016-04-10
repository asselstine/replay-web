require 'rails_helper'

describe StravaActivitySync do
  LIST_ATHLETE_ACTIVITIES = JSON.parse(
    File.read(Rails.root.join('spec',
                              'fixtures',
                              'strava_list_athlete_activities.json')))
  RETRIEVE_ACTIVITY_STREAMS = JSON.parse(
    File.read(Rails.root.join('spec',
                              'fixtures',
                              'strava_retrieve_activity_streams.json')))

  let(:user) { create(:user) }
  let(:client) { double(Strava::Api::V3::Client) }

  subject { StravaActivitySync.new(user: user) }

  before(:each) do
    allow(subject).to receive(:client).and_return(client)
  end

  describe '#call' do
    context 'brand new activity' do
      it 'should build rides that do not yet exist' do
        expect(client).to receive(:list_athlete_activities)
          .and_return(LIST_ATHLETE_ACTIVITIES)
        expect(client).to receive(:retrieve_activity_streams)
          .and_return(RETRIEVE_ACTIVITY_STREAMS)
        expect do
          subject.call
        end.to change { user.rides.count }.by(1)
        ride = user.rides.first
        expect(ride.strava_activity_id).to eq('8529483')
        expect(ride.strava_name).to eq('Afternoon Ride')
        data = ride.time_series_data
        expect(data.latitudes.count).to eq(4)
        expect(data.latitudes.first).to eq(38.603734)
        expect(data.longitudes.first).to eq(-122.864112)
        expect(data.timestamps.first).to eq(ride.strava_start_at)
      end
    end
  end
end
