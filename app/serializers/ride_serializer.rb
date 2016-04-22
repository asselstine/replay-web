class ActivitySerializer < BaseSerializer
  attributes :strava_name, :strava_start_at, :start_at, :end_at
  attributes :interpolated_coords
  has_one :user
  has_many :locations
end
