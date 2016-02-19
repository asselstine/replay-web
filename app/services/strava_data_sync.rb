class StravaDataSync
  include Service
  include Virtus.model

  attribute :user, User

  def call
    return if client.nil? || Rails.env.test?
    ActiveRecord::Base.transaction do
      activities = client.list_athlete_activities
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
    streams = client.retrieve_activity_streams(ride.strava_activity_id, 'latlng,time')
    latlng = streams[0]
    time = streams[1]
    # will be an array of [[lat,lng], seconds]
    datapoints = latlng['data'].zip time['data']
    datapoints.each do |dp|
      location = ride.locations.create({
        latitude: dp[0][0],
        longitude: dp[0][1],
        timestamp: ride.strava_start_at.since( dp[1].to_i )
      })
      debug("Created new location: #{location}")
    end
  end

  def client
    @_client ||= Strava::Api::V3::Client.new(access_token: @user.strava_account.token) if @user.strava_account
  end

  def debug(str)
    Rollbar.debug("StravaDataSync(user: #{user.id}): #{str}")
  end
end
