# rubocop:disable Style/ClassAndModuleChildren
class FFMPEG::VideoSlice < FFMPEG::Service
  attribute :video
  attribute :start_at
  attribute :end_at
  attribute :video_start_at

  def call
    download_video(video)
    slice_video
    output_filepath
  end

  private

  def slice_video
    run(<<-SHELL
      ffmpeg -strict -2 \
             -ss #{start}\
             -i #{video_filepath(video)}\
             -t #{duration}\
             #{output_filepath}
    SHELL
       )
  end

  def start
    self.class.relative_time(start_at, video_start_at)
  end

  def duration
    self.class.relative_time(end_at, start_at)
  end

  def output_filepath
    "#{tmpdir}/#{timestamp}.mp4"
  end

  def timestamp
    @timestamp ||= Time.now.strftime('%Y%m%d%H%M%S')
  end
end
