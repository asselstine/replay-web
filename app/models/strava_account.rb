class StravaAccount < ActiveRecord::Base
  mattr_accessor :client_class do
    Strava::Api::V3::Client
  end

  belongs_to :user

  enum sync_job_status: [
    :waiting,
    :working,
    :done,
    :failed,
    :no_job
  ]

  def client
    @_client ||= self.class.client_class.new(access_token: token)
  end
end
