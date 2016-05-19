class ActivitySerializer < BaseSerializer
  attributes :strava_name, :strava_start_at, :start_at, :end_at
  has_one :user
end
