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
    visit new_recording_session_camera_path(@recording_session) 
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
