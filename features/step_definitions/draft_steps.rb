Given %(I have a video draft) do
  step %(I have an activity)
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
  step %(I have an activity)
  @segment_effort ||= create(:segment_effort,
                             activity: @activity)
end

Given %(the video upload is updated with the effort timestamp) do
  update_video_upload_timestamp(@segment_effort.start_at)
  step %(I update the video)
end

Then %(I can see the video draft) do
  expect(page).to have_content(@video_draft.name)
end

Then %(I can see the segment effort) do
  expect(page).to have_content(@segment_effort.name)
end

Then %(I can see a video draft) do
  expect(VideoDraft.count).to be > 0
  expect(page).to have_content(VideoDraft.last.name)
end

def stringtime(time)
  time.strftime('%Y-%m-%dT%T.%L') # '06-30-1984T12:12:12.004'
end

def offset_time(time, offset)
  Time.zone.at(time.to_f + offset)
end
