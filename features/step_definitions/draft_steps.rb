Given %(I have a video draft) do
  step %(I have an activity)
  @video_draft = create(:video_draft, activity: @activity)
end

When %(I browse drafts) do
  visit drafts_path
end

Then %(my video draft is listed) do
  expect(page).to have_css(".video-draft-tile[data-video-draft-id='#{@video_draft.id}']")
end

When %(I click on the video draft) do
  find(".video-draft-tile[data-video-draft-id='#{@video_draft.id}']").click
end

Then %(I should be able to play the video draft) do
  within '.video-draft' do
    expect(page).to have_content(@video_draft.name)
    expect(page).to have_css('video')
  end
end

Given %(the video upload is updated with the activity timestamp) do
  scrub = BigDecimal.new('0.05')
  update_video_upload_timestamp(@activity.start_at + 1.second, scrub)
  step %(I update the video)
  expect(@upload.video.reload.start_at)
    .to(eq(@segment_effort.reload.start_at + 1.second - scrub.seconds))
end

Then %(I can see the video draft) do
  expect(page).to have_content(@video_draft.name)
end

Then %(I can see the segment effort) do
  expect(page).to have_content(@segment_effort.name)
end

Then %(I can see a video draft) do
  expect(VideoDraft.count).to be_positive
  expect(page).to have_css(".video-draft-tile[data-video-draft-id='#{VideoDraft.last.id}']")
end

def stringtime(time)
  time.strftime('%Y-%m-%dT%T.%L') # '06-30-1984T12:12:12.004'
end

def offset_time(time, offset)
  Time.zone.at(time.to_f + offset)
end
