class ActivitySerializer < BaseSerializer
  attributes :strava_name, :strava_start_at, :start_at, :end_at
  attributes :latitudes, :longitudes, :timestamps_f, :cspline_latlngs, :colour

  has_one :user

  def timestamps_f
    object.timestamps.map(&:to_f)
  end

  def cspline_latlngs
    now = object.timestamps.first
    result = []
    while now < object.timestamps.last
      now += 0.25.seconds
      result << object.coords_at(now)
    end
    result
  end
end
