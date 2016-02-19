class RemoteCutter < Cutter
  def download_videos
    video_edit.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    Rollbar.debug(<<-STRING
      RemoteCutter: download_video: #{video.mp4} to #{video_filepath(video)}"
    STRING
                 )
    S3.get(video.mp4, video_filepath(video))
  end
end
