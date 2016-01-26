class RemoteCutter < Cutter
  def download_videos
    edits.videos.each do |video|
      download_video(video)
    end
  end

  def download_video(video)
    S3.get(video.mp4, video_filepath(video))
  end

  def upload_video
    super
    S3.upload(edit_filepath, edit.output_key)
  end
end
