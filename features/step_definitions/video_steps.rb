When %(I upload a video to the camera) do
  visit camera_path(@camera)
  click_link 'New Video'
  expect(page).to have_content('Add Video')
  find('#video_source_key', visible: false).set 'http://fakeness.com'
  find('#video_filename', visible: false).set 'fakee.mp4'
end

When %(I create the video) do
  click_button 'Create Video'
end

Given %(there is a video) do
  @video = create(:video,
                  mp4_url: '/assets/dan_session1-frame.mp4',
                  filename: 'dan_session1-frame.mp4',
                  status: Video::STATUS_COMPLETE)
end

Then %(there should be a new video for the camera) do
  visit camera_path(@camera)
  expect(page).to have_css('a', text: 'fakee.mp4')
end

When %(I scrub to the slate and set the timestamp) do
  visit video_path(@video)
  expect(page).to have_content(@video.filename)
  fill_in :date, with: '06-30-1984'
  fill_in :timezone, with: '-8:00'
  fill_in :timestamp, with: '12:12:12.000'
  find('body').click
  execute_script <<-JAVASCRIPT
    $('video')[0].load();
    $('video')[0].currentTime = 0.02;
  JAVASCRIPT
  expect(page).to have_content('20ms')
end

Then %(I should see the adjusted start and end times) do
  expect(page).to have_content('1984-06-30T20:12:11.980Z')
  expect(page).to have_content('1984-06-30T20:12:12.087Z')
end

When %(I update the video) do
  click_button 'Set'
  step %(the record should have been updated)
end

Then %(the video should have correct start and end times) do
  expect(@video.reload.start_at).to eq(
    DateTime.parse('1984-06-30T20:12:11.980Z'))
  expect(@video.end_at).to eq(
    DateTime.parse('1984-06-30T20:12:12.087Z'))
end

Then %(the video should have the correct duration) do
  expect(@video.duration_ms).to eq(107)
end
