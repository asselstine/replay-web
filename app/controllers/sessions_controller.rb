class SessionsController < Devise::SessionsController
  def create
    super do |user|
      Synchronize.call(user: user)
    end
  end
end
