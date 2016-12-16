When %(I browse activities) do
  visit activities_path
end

Then %(I can see the activity) do
  expect(page).to have_content(@activity.strava_name)
end
