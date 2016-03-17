class RemoteEditProcessor < EditProcessor
  def download_videos
    edit.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    return if File.exist? video_filepath(video)
    run("wget --quiet '#{video.file.file.authenticated_url}' -O #{video_filepath(video)}")
  end
end
