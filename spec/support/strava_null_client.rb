require 'json'

class StravaNullClient
  def initialize(access_token)
  end

  def list_athlete_activities(*_)
    @list_athlete_activities ||= JSON.parse(
      File.read(
        Rails.root.join('spec/fixtures/strava_list_athlete_activities.json')
      )
    )
  end

  def retrieve_activity_streams(*_)
    @retrieve_activity_streams ||= JSON.parse(
      File.read(
        Rails.root.join('spec/fixtures/strava_retrieve_activity_streams.json')
      )
    )
  end

  def retrieve_an_activity(*_)
    @retrieve_an_activity ||= JSON.parse(
      File.read(
        Rails.root.join('spec/fixtures/strava_retrieve_an_activity.json')
      )
    )
  end
end
