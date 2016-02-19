class StravaAccount < ActiveRecord::Base
  belongs_to :user

  def client
    @_client ||= if Rails.env.test?
      StravaNullClient.new
    else
      Strava::Api::V3::Client.new(access_token: token)
    end
  end
end
