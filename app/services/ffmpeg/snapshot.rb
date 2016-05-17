class FFMPEG::Snapshot < FFMPEG::Service
  attribute :video, Video
  attribute :time_ms, Integer, default: 0
  attribute :image_path, String

  def call
    timestamp = seconds_to_ffmpeg_time(@time_ms)
    video_path = cache_video(@video)
    run("ffmpeg -ss #{timestamp} -i #{video_path} -vframes 1 #{image_path}")
  end

  private

  def image_path
    "#{tmp_dir_path}/video-#{video.id}/snapshot.jpg"
  end
end
