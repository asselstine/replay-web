Given %(a static setup exists) do
  @setup = Setup.create(name: 'Here', location: 'static')
end

When %(I go to create a new setup) do
  visit new_setup_path
end

When %(I enter the setup name) do
  fill_in :setup_name, with: 'Camera Setup 1'
end

When %(I create a new setup) do
  step %(I go to create a new setup)
  step %(I enter the setup name)
  step %(I create the new setup)
end

When %(I create the new setup) do
  expect do
    click_button 'Create Setup'
    step %(the record should have been created)
  end.to change { Setup.count }.by(1)
  @setup = Setup.last
end

Then %(the setup should be listed) do
  visit setups_path
  expect(page).to have_css('a', text: @setup.name)
end

When %(I go to edit the setup) do
  visit edit_setup_path(@setup)
end

When %(I select a static location and center it on my position) do
  react_select('.setup-location', 'Static')
  step %(I update the setup location with my current location)
end

When %(I select strava location) do
  react_select('.setup-location', 'Strava')
end

When %(I update the setup location with my current location) do
  latitude = -49
  longitude = 120
  page.execute_script <<-JAVASCRIPT
      navigator.geolocation.getCurrentPosition = function (fxn) {
        fxn({ coords: { latitude: #{latitude}, longitude: #{longitude} } });
      }
  JAVASCRIPT
  click_link 'Center'
end

Then %(the setup should be a static location) do
  expect(@setup).to be_static
  expect(@setup.reload.latitude).to eq(-49)
  expect(@setup.longitude).to eq(120)
end

Then %(the setup should be for strava) do
  expect(@setup).to be_strava
end

When %(I update the setup range to $range) do |range|
  fill_in :setup_range_m, with: range
end

Then %(the setup range should be $range) do |range|
  expect(@setup.reload.range_m).to eq(range.to_f)
end

When %(I save the existing setup) do
  click_button 'Save Setup'
  step %(the record should have been updated)
end

Then %(the setup should have a video) do
  expect(@setup.videos).to_not be_empty
end

Given %(I have a strava setup) do
  @strava_account ||= create(:strava_account, user: @user)
  @user.reload
  @setup ||= create(:setup, location: :strava, user: @user)
end
#
# Then %(the setup location timestamp should eq the session start) do
#   expect(Setup.last.time_series_data.timestamps.first)
#     .to eq(@recording_session.start_at.change(sec: 0))
# end
