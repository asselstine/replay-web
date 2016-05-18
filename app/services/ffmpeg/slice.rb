# rubocop:disable Style/ClassAndModuleChildren
class FFMPEG::Slice < FFMPEG::Service
  attribute :video
  attribute :start_at
  attribute :end_at

  def call
    cache_video(video)
    slice_video
    output_filepath
  end

  private

  def slice_video
    run(<<-SHELL
      ffmpeg -strict -2 \
             -ss #{start}\
             -i #{cached_video_filepath(video)}\
             -t #{duration}\
             #{output_filepath}
    SHELL
       )
  end

  def start
    self.class.relative_time(start_at, video.start_at)
  end

  def duration
    self.class.relative_time(end_at, start_at)
  end

  def output_filepath
    "#{tmp_dir_path}/#{timestamp}.mp4"
  end

  def timestamp
    @timestamp ||= Time.now.strftime('%Y%m%d%H%M%S')
  end
end
