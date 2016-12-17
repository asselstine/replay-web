class UserSerializer < ApplicationSerializer
  attributes :id, :email

  has_one :strava_account
end
