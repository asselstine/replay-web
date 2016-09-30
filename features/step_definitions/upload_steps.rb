Given %(the video upload belongs to the setup) do
  @upload.setups << @setup
end

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

Given %(I have a video upload) do
  step %(a user exists)
  step %(there is a setup)
  now = Time.zone.now.change(usec: 0).to_datetime
  @upload ||= create(:video_upload,
                     video: create(:video, start_at: now,
                                           end_at: now.since(10)),
                     user: @user,
                     setups: [@setup])
end

When %(I scrub to the slate and set the timestamp) do
  update_video_upload_timestamp(DateTime.parse('1984-06-30T20:12:12'))
end

When %(I update the video upload timestamp) do
  step %(I scrub to the slate and set the timestamp)
  # step %(I should see the adjusted start and end times)
  step %(I update the video)
end

# Then %(I should see the adjusted start and end times) do
#   expect(page).to have_content('1984-06-30T20:12:11.980Z')
#   expect(page).to have_content('1984-06-30T20:12:12.087Z')
# end

When %(I update the video) do
  click_link 'Save'
  step %(I see the success message "Saved upload dan_session1-frame")
end

Then %(the video should have correct start and end times) do
  expect(@upload.reload.video.start_at).to eq(
    DateTime.parse('1984-06-30T20:12:11.980Z')
  )
  expect(@upload.video.end_at).to eq(
    DateTime.parse('1984-06-30T20:12:12.087Z')
  )
end

Then %(the video should have the correct duration) do
  expect(@upload.video.duration).to eq(0.107)
end

Given %(there is a photo upload) do
  file = Rails.root.join('spec/fixtures/1x1_empty.jpg')
  @upload = create(:photo_upload,
                   user: @user,
                   photo: create(:photo,
                                 image: File.open(file)))
end

When %(I view the upload) do
  click_link 'Uploads'
  expect(page).to have_content(@upload.filename)
  find(:xpath, "//div[@data-upload-id='#{@upload.id}']").click
end

Then %(I should see the photo) do
  within '.view-photo-modal' do
    expect(page).to have_content(@upload.filename)
  end
end

def update_video_upload_timestamp(time)
  step %(I view the upload)
  within '.video-upload-modal' do
    expect(page).to have_content(@upload.filename)
    fill_in_video_draft_timestamp(time)
    find('.modal-content').click
  end
  scrub_video_upload_s(time, 0.02)
end

def scrub_video_upload_s(time, seconds)
  scrub_video_to_s(seconds)
  expect(page).to have_content("#{(seconds * 1000).to_i}ms")
  expect_scrub_offset(time, seconds)
end

def expect_scrub_offset(time, seconds)
  expect(page).to have_content(stringtime(offset_time(time, -seconds)))
  expect(page).to have_content(stringtime(offset_time(time, 0.107 - seconds)))
  # expect(page).to have_content('1984-06-30T20:12:11.980Z')
  # expect(page).to have_content('1984-06-30T20:12:12.087Z')
end

def fill_in_video_draft_timestamp(time)
  fill_in :date, with: time.strftime('%m-%d-%Y') # '06-30-1984'
  fill_in :timezone, with: time.strftime('%z') # '-8:00'
  fill_in :timestamp, with: time.strftime('%T.%L') # '12:12:12.000'
end

def scrub_video_to_s(seconds)
  execute_script <<-JAVASCRIPT
    $('video')[0].load();
    $('video')[0].currentTime = #{seconds};
  JAVASCRIPT
end
