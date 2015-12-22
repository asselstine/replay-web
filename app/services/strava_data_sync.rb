class StravaDataSync

  attr_accessor :user

  def initialize(params)
    @user = params[:user]
  end

  def call
    return if client.nil?
    activities = client.list_athlete_activities
    activities.each do |activity|
      debug("Checking activity #{activity['id']} with name #{activity['name']}")
      ride = @user.rides.where(strava_activity_id: activity['id']).first
      unless ride
        ride = @user.rides.create({
          strava_activity_id: activity['id'],
          strava_name: activity['name'],
          strava_start_at: activity['start_date']
        })       
        debug("Created new ride: #{ride.to_s}")
        streams = client.retrieve_activity_streams(activity['id'], 'latlng,time')
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
      else
        debug("Ride already exists for the activity: #{ride}")
      end
    end
  end

  protected

  def client
    @_client ||= Strava::Api::V3::Client.new(access_token: @user.strava_account.token) if @user.strava_account
  end

  def debug(str)
    Rails.logger.debug("StravaDataSync(user: #{user.id}): #{str}")
  end
end
