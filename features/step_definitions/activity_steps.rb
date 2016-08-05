Given %(I have an activity) do
  step %(a user exists)
  @activity ||= create(:activity, user: @user)
end

When %(I have a new activity during the video upload near the setup) do
  step %(a user exists)
  step %(I have a video upload)
  @activity = create(:activity,
                     strava_start_at: @upload.video.start_at,
                     timestamps: Array.new(10) { |n| n },
                     latitudes: Array.new(10) { @upload.setups.first.latitude },
                     longitudes: Array.new(10) { @upload.setups.first.longitude },
                     user: @user)
end
