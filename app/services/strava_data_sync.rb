class StravaDataSync

  attr_accessor :user

  def initialize(params)
    @user = params[:user]
  end

  def call
    strava_account = @user.strava_account
    return if strava_account.nil?

    @client = Strava::Api::V3::Client.new(strava_account.token)
    
  end

end
