class SessionsController < Devise::SessionsController
  def create
    super do |user|
      if user
        StravaDataSync.call(user: user)
        GenerateEdits.call(user: user)
      end
    end
  end
end
