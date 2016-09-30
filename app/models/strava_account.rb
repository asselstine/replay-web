class StravaAccount < ActiveRecord::Base
  @client_class = Strava::Api::V3::Client
  cattr_accessor :client_class

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
