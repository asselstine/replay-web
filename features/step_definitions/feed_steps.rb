Given %(I have an edit) do
  @user ||= create(:user)
  @edit ||= @user.edits.create!
  @final_cut ||= @edit.final_cuts.create!(video:
    Video.create!(file:
      File.open(Rails.root.join('spec', 'fixtures', 'dan_session1-frame.mp4'))))
end

Given %(I've been on a ride) do
  @user ||= create(:user)
  @ride = create(:ride, user: @user)
  m = (1.0 / 11_120.0)
  t = DateTime.now
  @ride.locations = Array.new(10) do |i|
    create(:location,
           trackable: @ride,
           latitude: -49 + i * m, longitude: 128 + i * m,
           timestamp: t.since(i.seconds))
  end
end

Given %(there was video recorded on my ride) do
  loc = @ride.locations[3]
  @video = create(:video, start_at: @ride.start_at, end_at: @ride.end_at)
  @video.camera.locations = [create(:location,
                                    trackable: @video.camera,
                                    latitude: loc.latitude,
                                    longitude: loc.longitude,
                                    timestamp: loc.timestamp)]
  expect(@video).to be_valid
end

When %(I visit my feed) do
  visit feed_path
end

Then %(I should see a new edit) do
  expect(page).to have_css('.edit')
  expect(page).to have_content('dan_session1-frame.mp4')
end
