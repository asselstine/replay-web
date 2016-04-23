class StravaActivitySync
  include Service
  include Virtus.model

  DATE_FORMAT = '%Y-%m-%d %H:%M:%S.%3N'.freeze

  attribute :user, User

  def call
    debug('Connecting to Strava...')
    return if client.nil?
    debug('Starting Data sync...')
    ActiveRecord::Base.transaction do
      activities = client.list_athlete_activities
      debug("Found #{activities.length} activites")
      activities.each do |strava_activity|
        debug(<<-STRING
          Checking strava activity #{strava_activity['id']} \
          with name #{strava_activity['name']}
        STRING
             )
        existing = @user.activities.where(
          strava_activity_id: strava_activity['id']).first
        create_activity(strava_activity) unless existing
      end
    end
  end

  protected

  # rubocop:disable Metrics/AbcSize
  def create_activity(strava_activity)
    streams = client.retrieve_activity_streams(strava_activity['id'],
                                               'latlng,time')
    start_at = DateTime.parse(strava_activity['start_date'])
    activity = @user.activities.create(
      strava_activity_id: strava_activity['id'],
      strava_name: strava_activity['name'],
      strava_start_at: start_at,
      timestamps: timestamps(start_at, streams[1]['data']),
      latitudes: latitudes(streams[0]['data']),
      longitudes: longitudes(streams[0]['data'])
    )
    debug("Created new activity: #{activity}")
  end

  def timestamps(start_at, time_stream)
    time_stream.map do |t|
      start_at.since(t.to_i).strftime(DATE_FORMAT)
    end
  end

  def latitudes(latlng_stream)
    latlng_stream.map { |latlng| latlng[0] }
  end

  def longitudes(latlng_stream)
    latlng_stream.map { |latlng| latlng[1] }
  end

  def client
    user.strava_account.client
  end

  def debug(str)
    Rails.logger.debug("StravaActivitySync(user: #{user.id}): #{str}")
  end
end
