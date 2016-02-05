class RemoteCutter < Cutter
  def download_videos
    video_edit.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    Rails.logger.debug("RemoteCutter: download_video: #{video.mp4} to #{video_filepath(video)}")
    S3.get(video.mp4, video_filepath(video))
  end

  def upload_video
    super
    Rails.logger.debug("RemoteCutter: upload_video: #{edit_filepath} to #{video_edit.output_key}")
    S3.upload(edit_filepath, video_edit.output_key)
  end
end
