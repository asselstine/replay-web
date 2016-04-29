When %(I upload a video) do
  expect do
    click_link 'Uploads'
    click_link 'Upload Video'
    expect(page).to have_content('Upload Video')
    attach_file :upload_video_attributes_file,
                Rails.root.join('spec/fixtures/dan_session1-frame.mp4')
    click_button 'Create Upload'
    step %(the record should have been created)
  end.to change { Upload.count }.by(1)
  @upload = Upload.last
end

Then %(the video upload should be listed) do
  visit uploads_path
  expect(page).to have_content('dan_session1-frame')
end

Given %(there is a video upload) do
  file = Rails.root.join('spec/fixtures/dan_session1-frame.mp4')
  @upload = create(:upload,
                   video: create(:video, file: File.open(file)))
end

When %(I scrub to the slate and set the timestamp) do
  visit upload_path(@upload)
  expect(page).to have_content(@upload.video.filename)
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
  expect(@upload.reload.start_at).to eq(
    DateTime.parse('1984-06-30T20:12:11.980Z'))
  expect(@upload.end_at).to eq(
    DateTime.parse('1984-06-30T20:12:12.087Z'))
end

Then %(the video should have the correct duration) do
  expect(@upload.video.duration_ms).to eq(107)
end
