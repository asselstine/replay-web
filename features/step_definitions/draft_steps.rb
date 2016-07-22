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
  expect(page).to have_content(@video_draft.name)
end

When %(I click on the video draft) do
  find(:xpath, "//a[@data-video-draft-id='#{@video_draft.id}']").click
end

Then %(I should be able to play the video draft) do
  within '.video-draft' do
    expect(page).to have_content(@video_draft.name)
    expect(page).to have_css('video')
  end
end

Given %(I have a segment effort) do
  @segment_effort = create(:segment_effort,
                           activity: @activity)
end

Given %(the video upload is updated with the effort timestamp) do
  update_video_upload_timestamp(@segment_effort.start_at)
end

Then %(I can see the segment effort video) do
  expect(page).to have_content(@segment_effort.name)
end
