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
      activities.each do |activity|
        debug("Checking activity #{activity['id']} with name #{activity['name']}")
        ride = @user.rides.where(strava_activity_id: activity['id']).first
        create_ride(activity) unless ride
      end
    end
  end

  protected

  def create_ride(activity)
    ride = @user.rides.create(
      strava_activity_id: activity['id'],
      strava_name: activity['name'],
      strava_start_at: activity['start_date']
    )
    debug("Created new ride: #{ride}")
    add_locations(ride)
  end

  def add_locations(ride)
    streams = client.retrieve_activity_streams(ride.strava_activity_id,
                                               'latlng,time')
    ride.create_time_series_data(
      timestamps: timestamps(ride, streams[1]['data']),
      latitudes: latitudes(streams[0]['data']),
      longitudes: longitudes(streams[0]['data']))
    debug("Created locations for ride: #{ride}")
  end

  def timestamps(ride, time_stream)
    time_stream.map do |t|
      ride.strava_start_at.since(t.to_i).strftime(DATE_FORMAT)
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
