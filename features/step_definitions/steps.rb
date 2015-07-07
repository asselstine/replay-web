Given /I'm logged in/ do
  @user = create(:user)
  visit new_user_session_path
  fill_in :user_email, :with => @user.email
  fill_in :user_password, :with => 'password'
  click_link_or_button 'Log in'
  expect(page).to have_content('All Rides')
end

Given /I've been somewhere/ do
  @location_sample = create(:location_sample, :ride => create(:ride, :user => @user))
end

Given /There was a photo taken near my location$/ do
  @photo = create(:dropbox_photo, :latitude => @location_sample.latitude, :longitude => @location_sample.longitude)
end

Given /There was a photo taken on the other side of the world/ do
  @photo = create(:dropbox_photo, :latitude => -@location_sample.latitude, :longitude => -@location_sample.longitude)
end

When /I go to my photos/ do
  visit photos_path
end

Then /^I should see a photo$/ do
  expect(page).to have_content(@photo.photo.url)
end

Then /^I should not see any photos$/ do
  expect(page).not_to have_content(@photo.photo.url)
end