module FFMPEG
  class ScrubImage < FFMPEG::Service
    attribute :video

    def call
      cache_video(video)
      explode_video
      create_scrub_images
    end

    private

    def create_scrub_images
      count = 0
      frame_filepaths.in_groups_of(30, false) do |group|
        index = count += 1
        output = scrub_image_output_filepath(index)
        stitch(group, output)
        video.scrub_images.create(index: index, image: File.new(output))
      end
    end

    def stitch(filepaths, output)
      convert = MiniMagick::Tool::Convert.new
      filepaths.each do |filepath|
        convert << filepath
      end
      convert.merge! ['+append']
      convert << output
      Rails.logger.info("Running: #{convert}")
      convert.call do |stdout, stderr, status|
        puts "STDOUT: #{stdout}"
        puts "STDERR: #{stderr}"
        puts "status: #{status}"
      end
    end

    def frame_filepaths
      return @frame_filepaths if @frame_filepaths
      sorted_filenames = Dir.entries(tmp_dir_path).select do |entry|
        /frame-\d+\.jpg/ =~ entry
      end.sort
      @frame_filepaths = sorted_filenames.map do |entry|
        "#{tmp_dir_path}/#{entry}"
      end
    end

    def explode_video
      run(<<-SHELL
        ffmpeg -strict -2 \
               -i #{cached_video_filepath(video)}\
               -vf scale=480:-1\
               -r 1\
               #{frame_output_path}
      SHELL
         )
    end

    def frame_output_path
      "#{tmp_dir_path}/frame-%04d.jpg"
    end

    def scrub_image_output_filepath(index)
      "#{tmp_dir_path}/scrub-image-#{index}.jpg"
    end
  end
end
