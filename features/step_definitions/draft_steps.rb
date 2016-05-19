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
  expect(page).to have_content(@video_draft.video.filename)
end
