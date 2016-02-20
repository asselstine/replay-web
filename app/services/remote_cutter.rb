class RemoteCutter < Cutter
  def download_videos
    video_edit.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    Rollbar.debug(<<-STRING
      RemoteCutter: download_video: #{video.file_url} to #{video_filepath(video)}"
    STRING
                 )
    video.file.cache_stored_file!
  end
end
