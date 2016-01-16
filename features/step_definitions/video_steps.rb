When %(I upload a video to the camera) do
  visit recording_session_camera_path(@recording_session, @camera)
  click_link 'New Video'
  find('#video_source', visible: false).set 'http://fakeness.com'
end

When %(I create the video) do
  click_button 'Create Video'
end

Then %(there should be a new video for the camera) do
  visit recording_session_camera_path(@recording_session, @camera)
  expect(page).to have_content('http://fakeness.com') 
end
