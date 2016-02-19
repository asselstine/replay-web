class SessionsController < Devise::SessionsController
  def create
    super do |user|
      if user && user.strava_account
        StravaDataSync.call(user: user)
        GenerateEdits.call(user: user)
      end
    end
  end
end
