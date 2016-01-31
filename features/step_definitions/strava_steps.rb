When %(I connect to Strava) do
  find('a.connect-strava').click
end

Then %(my Strava account should be connected) do
  expect(page).to have_content('Connected')
  expect(@user.strava_account).to_not be_nil
end
