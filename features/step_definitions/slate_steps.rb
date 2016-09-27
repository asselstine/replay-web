When %(I go to the slate) do
  visit slate_path
end

Then %(I should see the current server time) do
  time = Time.now
  expect(page).to have_css('.date', text: time.strftime('%b %-d %Y %:z'))
  expect(page).to have_css('.time', text: time.strftime('%H:%M'))
end
