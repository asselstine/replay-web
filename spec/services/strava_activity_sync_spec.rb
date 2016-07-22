require 'rails_helper'

describe StravaActivitySync do
  LIST_ATHLETE_ACTIVITIES = JSON.parse(
    File.read(
      Rails.root.join('spec/fixtures/strava_list_athlete_activities.json')
    )
  )
  RETRIEVE_ACTIVITY_STREAMS = JSON.parse(
    File.read(
      Rails.root.join('spec/fixtures/strava_retrieve_activity_streams.json')
    )
  )
  RETRIEVE_AN_ACTIVITY = JSON.parse(
    File.read(
      Rails.root.join('spec/fixtures/strava_retrieve_an_activity.json')
    )
  )

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
          .with(page: 1, page_size: 10)
          .and_return(LIST_ATHLETE_ACTIVITIES)
        expect(client).to receive(:retrieve_activity_streams)
          .and_return(RETRIEVE_ACTIVITY_STREAMS)
        expect(client).to receive(:retrieve_an_activity)
          .with('8529483', include_all_efforts: true)
          .and_return(RETRIEVE_AN_ACTIVITY)
        expect do
          subject.call
        end.to change { user.activities.count }.by(1)
        activity = user.activities.first
        expect(activity.strava_activity_id).to eq('8529483')
        expect(activity.strava_name).to eq('Afternoon Ride')
        expect(activity.latitudes.count).to eq(4)
        expect(activity.latitudes.first).to eq(38.603734)
        expect(activity.longitudes.first).to eq(-122.864112)
        expect(activity.velocities.first).to eq(10.1)
        expect(activity.velocities.last).to eq(3.3)
        expect(activity.strava_start_at).to eq(activity.strava_start_at)
        expect(activity.start_at).to eq(activity.strava_start_at)
        expect(activity.end_at).to eq(activity.strava_start_at.since(activity.timestamps.last))

        expect(activity.segment_efforts).to_not be_empty
        segment_effort = activity.segment_efforts.first
        expect(segment_effort.name).to eq('Dash for the Ferry')
        expect(segment_effort.start_at).to_not be_nil
        expect(segment_effort.end_at).to eq(segment_effort.start_at + 304.seconds)
        expect(segment_effort.elapsed_time).to eq(304)
        expect(segment_effort.moving_time).to eq(304)
        expect(segment_effort.start_index).to eq(5348)
        expect(segment_effort.end_index).to eq(6485)
        expect(segment_effort.kom_rank).to eq(2)
        expect(segment_effort.pr_rank).to eq(1)

        expect(segment_effort.segment).to_not be_nil
        segment = segment_effort.segment
        expect(segment.name).to eq('Dash for the Ferry')
        expect(segment.activity_type).to eq('Ride')
        expect(segment.distance).to eq(1055.11)
        expect(segment.average_grade).to eq(-0.1)
        expect(segment.maximum_grade).to eq(2.7)
        expect(segment.elevation_high).to eq(4.7)
        expect(segment.elevation_low).to eq(2.7)
        expect(segment.city).to eq('Oakland')
        expect(segment.state).to eq('CA')
        expect(segment.country).to eq('United States')
        expect(segment.is_private).to eq(false)
      end
    end

    it 'should loop correctly' do
      expect(client).to receive(:list_athlete_activities)
        .with(page: 1, page_size: 10)
        .and_return(Array.new(10))
      allow(subject).to receive(:find_or_create_activity).and_return(:activity)
      expect(client).to receive(:list_athlete_activities)
        .with(page: 2, page_size: 10)
        .and_return(Array.new(5))
      subject.call
    end

    context 'with start_at and end_at dates' do
      subject do
        StravaActivitySync.new(user: user,
                               start_at: t(0),
                               end_at: t(10))
      end

      it 'should include the parameters' do
        expect(client).to receive(:list_athlete_activities)
          .with(before: (t(10).to_i + 1),
                after: (t(0).to_i - 1),
                page: 1, page_size: 10)
          .and_return(Array.new(1))
        allow(subject).to receive(:find_or_create_activity)
          .and_return(:activity)
        subject.call
      end
    end
  end
end
