Given %(I have an edit) do
  @user ||= create(:user)
  @ride ||= create(:ride)
  @edit ||= @user.edits.create! ride: @ride
  @final_cut ||= @edit.final_cuts.create!(video:
    Video.create!(file:
      File.open(Rails.root.join('spec', 'fixtures', 'dan_session1-frame.mp4'))))
end

Given %(I've been on a ride) do
  @user ||= create(:user)
  @ride = create(:ride, user: @user)
  m = (1.0 / 11_120.0)
  t = DateTime.now
  @ride.create_time_series_data(
    timestamps: Array.new(10) { |i| t.since(i.seconds) },
    latitudes: Array.new(10) { |i| -49 + i * m },
    longitudes: Array.new(10) { |i| 128 + i * m }
  )
end

Given %(there was video recorded on my ride) do
  time = @ride.time_series_data.timestamps[3]
  lat = @ride.time_series_data.latitudes[3]
  long = @ride.time_series_data.longitudes[3]
  @video = create(:video, start_at: @ride.start_at, end_at: @ride.end_at)
  @video.camera.create_time_series_data timestamps: [time],
                                        latitudes: [lat],
                                        longitudes: [long]
  expect(@video).to be_valid
end

When %(I visit my feed) do
  visit feed_path
end

Then %(I should see a new edit) do
  expect(page).to have_css('.edit')
  expect(page).to have_content('dan_session1-frame.mp4')
end
