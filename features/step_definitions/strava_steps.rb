When %(I connect to Strava) do
  find('a.connect-strava').click
end

Then %(my Strava account should be connected) do
  expect(page).to have_content('Connected')
  expect(@user.strava_account).to_not be_nil
end

Then %(it should synchronize my data) do
  expect(ActiveJob::Base.queue_adapter.enqueued_jobs.last)
    .to include(job: SynchronizeJob)
end
