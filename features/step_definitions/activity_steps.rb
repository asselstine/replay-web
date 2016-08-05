Given %(I have an activity) do
  step %(a user exists)
  @activity ||= create(:activity, user: @user)
end

Given %(I have a segment effort) do
  step %(I have an activity)
  @segment_effort ||= create(:segment_effort,
                             activity: @activity)
end

When %(I have an activity matching the video upload) do
  step %(a user exists)
  step %(I have a video upload)
  @activity ||= create(:activity,
                       strava_start_at: @upload.video.start_at,
                       timestamps: Array.new(10) { |n| n },
                       latitudes: Array.new(10) do
                         @upload.setups.first.latitude
                       end,
                       longitudes: Array.new(10) do
                         @upload.setups.first.longitude
                       end,
                       user: @user)
end
