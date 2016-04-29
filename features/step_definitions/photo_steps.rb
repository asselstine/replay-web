Given %(there was a photo taken near my location) do
  index = @activity.timestamps.length / 2
  @photo = create(:photo,
                  timestamp: @activity.timestamps[index],
                  exif_latitude: @activity.latitudes[index],
                  exif_longitude: @activity.longitudes[index])
  @photo.setups.create!(name: 'Close',
                        latitude: @activity.latitudes[index],
                        longitude: @activity.longitudes[index])
end

When %(I go to my photos) do
  visit photos_path
end

When %(my account is synchronized) do
  BatchProcessor.call(user: @user)
end

Given %(there was a photo taken on the other side of the world) do
  index = @activity.timestamps.length / 2
  @photo = create(:photo,
                  timestamp: @activity.timestamps[index],
                  exif_latitude: -@activity.latitudes[index],
                  exif_longitude: -@activity.longitudes[index])
  @photo.setups.create!(name: 'Far',
                        latitude: -@activity.latitudes[index],
                        longitude: -@activity.longitudes[index])
end

When %(I go to my uploaded photos) do
  visit uploaded_photos_path
end

When %(I upload a photo without geo info where I've been) do
  expect do
    visit new_photo_path
    attach_file :'photo[image]', Rails.root.join('spec/fixtures/1x1_empty.jpg')
    click_link_or_button 'Create Photo'
    step %(the record should have been created)
  end.to change { Photo.count }.by(1)
  @photo = Photo.last
end

When %(I upload a photo with geo info) do
  expect do
    visit new_photo_path
    attach_file :'photo[image]', Rails.root.join('spec/fixtures/1x1_gps.jpg')
    click_link_or_button 'Create Photo'
    step %(the record should have been created)
  end.to change { Photo.count }.by(1)
  @photo = Photo.last
end

Then %(I should see a photo) do
  expect(page).to have_content(@photo.filename)
end

Then %(I should not see any geo info) do
  expect(page).not_to have_content('Lat/lng')
end

Then %(I should see the geo info) do
  expect(page).to have_content('50.860361')
  expect(page).to have_content('14.273586')
end

Then %(I should not see any photos) do
  expect(page).not_to have_content(@photo.filename)
end
