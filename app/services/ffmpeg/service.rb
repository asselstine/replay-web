# rubocop:disable Style/ClassAndModuleChildren
class FFMPEG::Service
  include Service
  include Virtus.model

  def self.relative_time(start_at, end_at)
    seconds_to_ffmpeg_time(end_at.to_f - start_at.to_f)
  end

  def self.seconds_to_ffmpeg_time(seconds_f)
    fraction = seconds_f % 1
    seconds = seconds_f % 60
    minutes = (seconds_f / 60) % 60
    hours = seconds_f / (60 * 60)
    format('%02d:%02d:%02d.%03d', hours, minutes, seconds, fraction)
  end

  protected

  def cache_video(video)
    return if File.exist? cached_video_filepath(video)
    if Rails.env.test?
      run "cp #{video.file_url} #{cached_video_filepath(video)}"
    else
      run(<<-SHELL
        wget --quiet '#{video.file.file.authenticated_url}' -O #{cached_video_filepath(video)}
      SHELL
         )
    end
    cached_video_filepath(video)
  end

  def run(command_string)
    debug "Running command '#{command_string}':"
    output = `#{command_string} 2>&1`
    raise "Error: #{output}" if $CHILD_STATUS != 0
  end

  def cached_video_filepath(video)
    "#{tmp_dir_path}/video-#{video.id}#{File.extname(video.filename)}"
  end

  def tmp_dir_path
    @tmp_dir_path ||= Dir.mktmpdir
  end

  def debug(str)
    Rails.logger.debug(str)
  end
end
