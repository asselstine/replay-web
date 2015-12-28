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
