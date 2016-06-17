class ActivitySerializer < BaseSerializer
  attributes :strava_name, :strava_start_at, :start_at, :end_at
  attributes :latitudes, :longitudes, :timestamps_f, :cspline_latlngs, :colour

  has_one :user

  def timestamps_f
    object.timestamps.map(&:to_f)
  end
end
