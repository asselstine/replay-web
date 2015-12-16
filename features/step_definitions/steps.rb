Given %(I'm logged in) do
  @user = create(:user)
  visit new_user_session_path
  fill_in :user_email, :with => @user.email
  fill_in :user_password, :with => 'password'
  click_link_or_button 'Log in'
  expect(page).to have_content('All Rides')
end

Given %(I've been somewhere) do
  @ride = create(:ride, user: @user)
  @locations = []
  10.times do |i|
    @location = create(:location, 
                       latitude: i/100.0, 
                       longitude: i/100.0, 
                       trackable: @ride) 
    @locations << @location
  end
end

Given %(There was a photo taken near my location) do
  @photo = create(:photo, timestamp: @location.timestamp, exif_latitude: @location.latitude, exif_longitude: @location.longitude)
end

Given %(There was a photo taken on the other side of the world) do
  @photo = create(:photo, timestamp: @location.timestamp, exif_latitude: -@location.latitude, exif_longitude: -@location.longitude)
end

Given %(I've done the trail Digger) do
  
end

When %(I go to my photos) do
  visit photos_path
end

When %(I go to my uploaded photos) do
  visit uploaded_photos_path
end

When %(I upload a photo without geo info where I've been) do
  visit new_photo_path
  attach_file :'photo[image]', Rails.root.join('spec','fixtures','1x1_empty.jpg')
  fill_in :photo_timestamp, with: @locations[2].timestamp.to_s
  click_link_or_button 'Create Photo'
  expect(page).to have_content('1x1_empty.jpg')
end

When %(I upload a photo with geo info) do
  visit new_photo_path
  attach_file :'photo[image]', Rails.root.join('spec','fixtures','1x1_gps.jpg')
  fill_in :photo_timestamp, with: @locations[2].timestamp.to_s
  click_link_or_button 'Create Photo'
  expect(page).to have_content('1x1_gps.jpg')
end

Then %(I should see a photo with geo info) do
  visit uploaded_photos_path
  expect(page).to have_css('.coords')
end

Then %(I should see a photo) do
  expect(page).to have_content(@photo.image.url)
end

Then %(I should not see any photos) do
  expect(page).not_to have_content(@photo.image.url)
end
