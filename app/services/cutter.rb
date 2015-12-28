class Cutter
  include Virtus.model
  attribute :edit, Edit

  #FFMPEG commands:
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
  # 

  def call
    begin
      setup
      download_videos
      extract_cuts
      stitch_cuts
      upload_video
    rescue
    end
  end

  def edit_filepath
    "#{tmpdir}/edit-#{edit.id}.mp4"
  end

  protected

  def setup
    puts("Tmp dir is #{tmpdir}")
    puts "Creating index..."
    File.open(index_filepath, 'w') do |file|
      edit.cuts.each do |cut|
        puts "Checking cut #{cut.id}: #{cut_filepath(cut)}"
        file.write(%(file '#{cut_filepath(cut)}'\n))
      end
    end
  end

  def index_filepath
    "#{tmpdir}/list.txt"
  end

  def download_videos
    edit.videos.each do |video|
      puts "Downloading video #{video.id}"
      run "cp #{video.source} #{video_filepath(video)}"
    end
  end

  def run(command_string)
    puts "Running command '#{command_string}':"
    output = %x(#{command_string})
    fail "Error: #{output}" if $? != 0
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
    format("%02d:%02d:%02d.%03d", hours, minutes, seconds, fraction)
  end

  def extract_cuts
    # ffmpeg -ss 00:00:01.0 -i small.mp4 -ss 00:00:01.0 -t 00:00:01 output.mp4 
    edit.cuts.each do |cut|
      run("ffmpeg -strict -2 -ss #{self.class.cut_start_time_s(cut)} -i #{video_filepath(cut.video)} -to #{self.class.cut_duration_s(cut)} #{cut_filepath(cut)}")    
    end
  end

  def stitch_cuts
    # ffmpeg -f concat -i mylist.txt -c copy output
    run("ffmpeg -strict -2 -f concat -i #{index_filepath} -c copy #{edit_filepath}")
  end

  def upload_video
    puts "View your new edit:\n"
    puts edit_filepath
    puts "The temp directory is:\n"
    puts tmpdir
    puts "There were #{edit.cuts.count} cuts."
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

end
