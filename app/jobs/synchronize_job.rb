class SynchronizeJob < ActiveJob::Base
  queue_as :default

  # rubocop:disable Lint/RescueException
  def perform(user_id)
    ActiveRecord::Base.clear_active_connections!
    user = User.find(user_id)
    strava_account = user.strava_account
    strava_account.working!
    begin
      Synchronize.call(user: user)
      Rails.logger.debug('SynchronizeJob Done!')
      strava_account.done!
    rescue Exception => e
      Rails.logger.error("SynchronizeJob: ERROR: #{e}")
      strava_account.failed!
      raise e
    end
  end
end
