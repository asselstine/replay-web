class ActivitySerializer < ApplicationSerializer
  attributes :strava_name, :strava_start_at, :start_at, :end_at, :start_at_f, :strava_activity_id
  attributes :latitudes, :longitudes, :timestamps_f, :cspline_latlngs, :colour

  has_one :user
  has_many :segment_efforts

  def start_at_f
    object.start_at.to_f
  end

  def timestamps_f
    object.timestamps
  end
end
