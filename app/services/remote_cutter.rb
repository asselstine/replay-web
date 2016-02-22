class RemoteCutter < Cutter
  def download_videos
    video_edit.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    return if File.exist? video_filepath(video)
    run("wget --quiet '#{video.file.file.authenticated_url}' -O #{video_filepath(video)}")
  end
end
