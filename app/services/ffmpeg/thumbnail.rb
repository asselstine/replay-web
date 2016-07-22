module FFMPEG
  class Thumbnail < FFMPEG::Service
    attribute :video, Video
    attribute :time_ms, Integer, default: 0

    # rubocop:disable Metrics/LineLength
    def call
      timestamp = self.class.seconds_to_ffmpeg_time(@time_ms)
      cache_video(@video)
      run("ffmpeg -ss #{timestamp} -i #{cached_video_filepath(@video)} -vframes 1 #{image_path}")
      video.create_thumbnail!(image: File.new(image_path), user: @video.user)
      video.save!
    end

    def image_path
      "#{tmp_dir_path}/video-#{video.id}-snapshot.jpg"
    end
  end
end
