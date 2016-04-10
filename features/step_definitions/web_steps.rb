Given %(I've been somewhere) do
  @ride = create(:ride, user: @user)
  @ride.create_time_series_data(
    timestamps: Array.new(10) { |i| DateTime.now.utc.since(i) },
    latitudes: Array.new(10) { |i| i / 100.0 },
    longitudes: Array.new(10) { |i| i / 100.0 })
end

When %(pry) do
  binding.pry
end

When %(I go to settings) do
  click_link 'Settings'
end

Given %(I'm logged in) do
  @user ||= create(:user)
  visit new_user_session_path
  fill_in :user_email, with: @user.email
  fill_in :user_password, with: 'password'
  click_link_or_button 'Log in'
  expect(page).to have_content 'Sign Out'
end

Then %(the record should have been updated) do
  expect(page).to have_content(I18n.t('flash.activerecord.update.success'))
end

Then %(the record should have been created) do
  expect(page).to have_content(I18n.t('flash.activerecord.create.success'))
end
