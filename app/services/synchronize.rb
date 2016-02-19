class Synchronize
  include Service
  include Virtus.model

  attribute :user, User

  def call
    StravaDataSync.call(user: user) if user && user.strava_account
    GenerateEdits.call(user: user) if user
  end
end
