class Synchronize
  include Service
  include Virtus.model

  attribute :user, User

  def call
    StravaActivitySync.call(user: user) if user.strava_account
    BatchEditor.call(user: user) if user
  end
end
