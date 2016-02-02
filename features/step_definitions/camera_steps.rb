Given %(there is a camera) do
  step %(I have an existing recording session)
  step %(there is an existing camera for the session)
end

When %(I go to edit the camera) do
  visit edit_camera_path(@camera)
end

When %(I update the camera location with my current location) do
  step %(I go to edit the camera)
  latitude = -49
  longitude = 120
  page.execute_script <<-JAVASCRIPT
      navigator.geolocation.getCurrentPosition = function (fxn) {
        fxn({ coords: { latitude: #{latitude}, longitude: #{longitude} } });
      }
  JAVASCRIPT
  click_link 'Center on my location'
  click_button 'Update Camera'
  step %(the record should have been updated)
end

Then %(the camera location should be updated) do
  expect(@camera.locations.first.latitude).to eq(-49)
  expect(@camera.locations.first.longitude).to eq(120)
end

When %(I update the camera range to $range) do |range|
  step %(I go to edit the camera)
  fill_in :camera_range_m, with: range
  click_button 'Update Camera'
  step %(the record should have been updated)
end

Then %(the camera range should be $range) do |range|
  expect(@camera.reload.range_m).to eq(range.to_f)
end

Then %(the camera should have a video) do
  expect(@camera.videos).to_not be_empty
end

Then %(the camera location timestamp should eq the session start) do
  expect(Camera.last.locations.first.timestamp)
    .to eq(@recording_session.start_at.change(sec: 0))
end
