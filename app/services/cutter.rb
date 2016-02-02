class Cutter
  include Virtus.model
  include Service
  attribute :video_edit, Edit

  # FFMPEG commands:
  #
  # slice out piece:
  # ffmpeg -ss 00:00:01.0 -i small.mp4 -ss 00:00:01.0 -t 00:00:01 output.mp4
  #
  # concat pieces:
  #
  # 1. create a file with:
  # # this is a comment
  # file '/path/to/file1'
  # file '/path/to/file2'
  # file '/path/to/file3'
  #
  # 2. concat files using
  #
  # ffmpeg -f concat -i mylist.txt -c copy output

  def call
    setup
    download_videos
    extract_cuts
    stitch_cuts
    upload_video
  end

  def edit_filepath
    "#{tmpdir}/edit-#{video_edit.id}.mp4"
  end

  def self.cut_duration_s(cut)
    to_ffmpeg_time(cut.end_at.to_f - cut.start_at.to_f)
  end

  def self.cut_start_time_s(cut)
    to_ffmpeg_time(cut.start_at.to_f - cut.video.start_at.to_f)
  end

  def self.to_ffmpeg_time(seconds_f)
    fraction = seconds_f % 1
    seconds = seconds_f % 60
    minutes = (seconds_f / 60) % 60
    hours = seconds_f / (60 * 60)
    format('%02d:%02d:%02d.%03d', hours, minutes, seconds, fraction)
  end

  protected

  def setup
    debug("Tmp dir is #{tmpdir}")
    debug 'Creating index...'
    File.open(index_filepath, 'w') do |file|
      video_edit.cuts.each do |cut|
        debug "Checking cut #{cut.id}: #{cut_filepath(cut)}"
        file.write(%(file '#{cut_filepath(cut)}'\n))
      end
    end
  end

  def index_filepath
    "#{tmpdir}/list.txt"
  end

  def download_videos
    video_edit.videos.each do |video|
      debug "Downloading video #{video.id}"
      run "cp #{video.mp4_url} #{video_filepath(video)}"
    end
  end

  def run(command_string)
    debug "Running command '#{command_string}':"
    output = `#{command_string} 2>&1`
    fail "Error: #{output}" if $CHILD_STATUS != 0
  end

  def extract_cuts
    # ffmpeg -ss 00:00:01.0 -i small.mp4 -ss 00:00:01.0 -t 00:00:01 output.mp4
    video_edit.cuts.each do |cut|
      run("ffmpeg -strict -2 -ss #{self.class.cut_start_time_s(cut)} -i #{video_filepath(cut.video)} -to #{self.class.cut_duration_s(cut)} #{cut_filepath(cut)}")
    end
  end

  def stitch_cuts
    # ffmpeg -f concat -i mylist.txt -c copy output
    run("ffmpeg -strict -2 -f concat -i #{index_filepath} -c copy #{edit_filepath}")
  end

  def upload_video
    debug "View your new edit:\n"
    debug edit_filepath
    debug "The temp directory is:\n"
    debug tmpdir
    debug "There were #{video_edit.cuts.count} cuts."
  end

  def cut_filename(cut)
    "cut-#{cut.id}.mp4"
  end

  def cut_filepath(cut)
    "#{tmpdir}/#{cut_filename(cut)}"
  end

  def video_filename(video)
    "video-#{video.id}.mp4"
  end

  def video_filepath(video)
    "#{tmpdir}/#{video_filename(video)}"
  end

  def tmpdir
    @tmp_dir_path ||= Dir.mktmpdir
  end

  def debug(str)
    Rails.logger.debug(str)
  end
end
