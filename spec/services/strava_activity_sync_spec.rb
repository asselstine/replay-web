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
      it 'should build activities that do not yet exist' do
        expect(client).to receive(:list_athlete_activities)
          .and_return(LIST_ATHLETE_ACTIVITIES)
        expect(client).to receive(:retrieve_activity_streams)
          .and_return(RETRIEVE_ACTIVITY_STREAMS)
        expect do
          subject.call
        end.to change { user.activities.count }.by(1)
        activity = user.activities.first
        expect(activity.strava_activity_id).to eq('8529483')
        expect(activity.strava_name).to eq('Afternoon Ride')
        expect(activity.latitudes.count).to eq(4)
        expect(activity.latitudes.first).to eq(38.603734)
        expect(activity.longitudes.first).to eq(-122.864112)
        expect(activity.timestamps.first).to eq(activity.strava_start_at)
        expect(activity.read_attribute(:start_at)).to eq(activity.timestamps.first)
        expect(activity.read_attribute(:end_at)).to eq(activity.timestamps.last)
      end
    end
  end
end
