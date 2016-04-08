class StravaAccount < ActiveRecord::Base
  belongs_to :user

  enum sync_job_status: [
    :waiting,
    :working,
    :done,
    :failed,
    :no_job
  ]

  def client
    @_client ||=
      if Rails.env.test?
        StravaNullClient.new
      else
        Strava::Api::V3::Client.new(access_token: token)
      end
  end
end
