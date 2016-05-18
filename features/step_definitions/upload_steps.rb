Given %(there is a setup) do
  @setup = create(:setup, user: @user)
end

When %(I go to upload) do
  click_link 'Uploads'
  click_link 'Upload'
  within '.new-upload' do
    expect(page).to have_content('Upload')
  end
end

When %(I add a video) do
  document_name = 'dan_session1-frame.mp4'
  within '.new-upload' do
    page.execute_script <<-JAVASCRIPT
      $('.direct-upload-form').trigger('s3_upload_complete',
                                       { filename: '#{document_name}',
                                         filetype: 'video/mp4',
                                         filesize: 33000,
                                         unique_id: 'f2lejk2f3',
                                         url: 'http://superfake.com/#{document_name}' })
    JAVASCRIPT
  end
end

When %(I add a photo) do
  document_name = 'snapshot.jpg'
  within '.new-upload' do
    page.execute_script <<-JAVASCRIPT
      $('.direct-upload-form').trigger('s3_upload_complete',
                                       { filename: '#{document_name}',
                                         filetype: 'image/jpg',
                                         filesize: 33000,
                                         unique_id: 'r3fg23',
                                         url: 'http://superfake.com/#{document_name}' })
    JAVASCRIPT
  end
end

When %(I select a setup) do
  react_select('.new-upload .Select', @setup.name)
end

When %(I finish the video upload) do
  expect do
    click_button 'Upload'
    step %(the video upload should have been successful)
  end.to change { Upload.count }.by(1)
  @upload = Upload.last
end

When %(I finish the photo upload) do
  expect do
    click_button 'Upload'
    step %(the photo upload should have been successful)
  end.to change { Upload.count }.by(1)
  @upload = Upload.last
end

Then %(the video upload should be listed) do
  visit uploads_path
  expect(page).to have_content('dan_session1-frame')
end

Then %(the photo upload should be listed) do
  visit uploads_path
  expect(page).to have_content('snapshot.jpg')
end

Then %(the photo upload should have been successful) do
  step %(I see the success message "Uploaded snapshot.jpg")
end

Then %(the video upload should have been successful) do
  step %(I see the success message "Uploaded dan_session1-frame")
end

Then %(the upload should include the setup) do
  expect(@upload.setups).to include(@setup)
end

Given %(there is a video upload) do
  file = Rails.root.join('spec/fixtures/dan_session1-frame.mp4')
  @upload = create(:video_upload,
                   user: @user,
                   video: create(:video,
                                 file: File.open(file)))
end

When %(I scrub to the slate and set the timestamp) do
  click_link 'Uploads'
  click_link @upload.filename
  within '.edit-upload-modal' do
    expect(page).to have_content(@upload.filename)
    fill_in :date, with: '06-30-1984'
    fill_in :timezone, with: '-8:00'
    fill_in :timestamp, with: '12:12:12.000'
    find('.modal-content').click
  end
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
  click_link 'Save'
  step %(I see the success message "Saved upload dan_session1-frame")
end

Then %(the video should have correct start and end times) do
  expect(@upload.reload.video.start_at).to eq(
    DateTime.parse('1984-06-30T20:12:11.980Z'))
  expect(@upload.video.end_at).to eq(
    DateTime.parse('1984-06-30T20:12:12.087Z'))
end

Then %(the video should have the correct duration) do
  expect(@upload.video.duration_ms).to eq(107)
end
