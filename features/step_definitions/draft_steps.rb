Given %(I have an activity) do
  @activity = create(:activity, user: @user)
end

Given %(I have a video draft) do
  @video_draft = create(:video_draft, activity: @activity)
end

When %(I browse drafts) do
  visit drafts_path
end

Then %(my video draft is listed) do
  expect(page).to have_content(@video_draft.activity.strava_name)
end

When %(I click on the video draft) do
  find(:xpath, "//div[@data-video-draft-id='#{@video_draft.id}']").click
end

Then %(I should be able to play the video draft) do
  within '.video-draft-modal' do
    expect(page).to have_content(@video_draft.activity.strava_name)
    expect(page).to have_css('video')
  end
end