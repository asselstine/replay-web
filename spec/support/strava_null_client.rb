require 'json'

class StravaNullClient
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

  def initialize(access_token)
  end

  def list_athlete_activities(*_)
    LIST_ATHLETE_ACTIVITIES
  end

  def retrieve_activity_streams(*_)
    RETRIEVE_ACTIVITY_STREAMS
  end

  def retrieve_an_activity(*_)
    RETRIEVE_AN_ACTIVITY
  end
end
