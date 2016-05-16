When %(I upload a video) do
  document_name = 'dan_session1-frame'
  expect do
    click_link 'Uploads'
    click_link 'Upload'
    within '.new-upload' do
      expect(page).to have_content('Upload Video')
      page.execute_script <<-JAVASCRIPT
        $('.direct-upload-form').trigger('s3_upload_complete',
                                         { filename: '#{document_name}',
                                           url: 'http://superfake.com/#{document_name}' })
      JAVASCRIPT
      click_button 'Upload'
    end
    step %(the upload should have been successful)
  end.to change { Upload.count }.by(1)
  @upload = Upload.last
end

Then %(the video upload should be listed) do
  visit uploads_path
  expect(page).to have_content('dan_session1-frame')
end

Then %(the upload should have been successful) do
  step %(I see the success message "Uploaded video dan_session1-frame")
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
