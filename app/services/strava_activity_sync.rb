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
    location_attributes = streams_to_location_attributes(ride, streams)
    bulk_insert_locations(ride, location_attributes)
    debug("Created locations for ride: #{ride}")
  end

  def bulk_insert_locations(ride, location_attributes)
    raw_sql = <<-SQL
      INSERT INTO #{Location.table_name} (timestamp, latitude, longitude, trackable_id, trackable_type) \
      VALUES
    SQL
    raw_sql += location_attributes.map do |attrs|
      sql = '('
      sql += "'#{attrs[:timestamp]}', '#{attrs[:latitude]}', "
      sql += "'#{attrs[:longitude]}', #{ride.id}, '#{Ride.name}'"
      sql + ')'
    end.join(', ') + ';'
    ActiveRecord::Base.connection.execute raw_sql
  end

  def streams_to_location_attributes(ride, streams)
    latlng = streams[0]
    time = streams[1]
    # will be an array of [[lat,lng], seconds]
    datapoints = latlng['data'].zip time['data']
    datapoints.map do |dp|
      {
        latitude: dp[0][0],
        longitude: dp[0][1],
        timestamp: ride.strava_start_at.since(dp[1].to_i).strftime(DATE_FORMAT)
      }
    end
  end

  def client
    user.strava_account.client
  end

  def debug(str)
    Rails.logger.debug("StravaActivitySync(user: #{user.id}): #{str}")
  end
end
