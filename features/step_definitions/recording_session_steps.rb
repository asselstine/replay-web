When %(I go to my recording sessions) do
  visit recording_sessions_path
end

Given %(I have created a recording session) do
  @recording_session = @user.recording_sessions.create(name: 'Session 1')
  expect(@recording_session).to be_persisted
end

Then %(I should see my existing recording session) do
  expect(page).to have_content('Session 1')
end

When %(I create a new recording session) do
  visit new_recording_session_path
  fill_in :recording_session_name, with: 'New Session'
  click_button 'Create Recording session'
end

Then %(a new recording session should exist) do
  expect( RecordingSession.where(name: 'New Session').first ).to_not be_nil
end

When %(I have an existing recording session) do
  @recording_session = create(:recording_session, user: @user)
end

When %(I create a new camera for the recording session) do
  expect do 
    visit recording_session_path(@recording_session)
    click_link 'New Camera'
    fill_in :camera_name, with: 'Camera 1'
    click_button 'Create Camera'
  end.to change { Camera.count }.by(1)
end

Then %(the camera should be listed in the recording session) do
  visit recording_session_path(@recording_session)
  expect(page).to have_content('Camera 1')
end

Given %(there is an existing camera for the session) do
  @camera = @recording_session.cameras.create(name: 'Existing Camera')
end

When %(I go to edit the camera) do
  visit edit_recording_session_camera_path(@recording_session, @camera) 
end

When %(I update the camera location with my current location) do
  step %(I go to edit the camera)
  latitude = -49
  longitude = 120
  page.execute_script("navigator.geolocation.getCurrentPosition = function (fxn) { fxn({ coords: { latitude: #{latitude}, longitude: #{longitude} } }); }")
  click_link 'Center on my location'
  click_button 'Update Camera'
  step %(expect creation success)
end

Then %(expect creation success) do
  expect(page).to have_content('Created the new record')
end

Then %(the camera location should be updated) do
  expect(@camera.locations.first.latitude).to eq(-49)
  expect(@camera.locations.first.longitude).to eq(120)
end

When %(I update the camera range to $range) do |range|
  step %(I go to edit the camera)
  fill_in :camera_range_m, with: range
  click_button 'Update Camera'
  step %(expect creation success)
end

Then %(the camera range should be $range) do |range|
  expect(@camera.reload.range_m).to eq(range.to_f)
end
