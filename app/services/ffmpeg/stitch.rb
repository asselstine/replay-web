# rubocop:disable Style/ClassAndModuleChildren
class FFMPEG::Stitch < FFMPEG::Service
  def create_index
    debug "Tmp dir is #{tmpdir}"
    debug 'Creating index...'
    File.open(index_filepath, 'w') do |file|
      edit.cuts.each do |cut|
        debug "Checking cut #{cut.id}: #{cut_filepath(cut)}"
        file.write(%(file '#{cut_filepath(cut)}'\n))
      end
    end
  end

  def index_filepath
    "#{tmpdir}/list.txt"
  end

  def stitch_cuts
    # ffmpeg -f concat -i mylist.txt -c copy output
    run(<<-SHELL
      ffmpeg -strict -2 -f concat -i #{index_filepath} -c copy #{stitched_filepath}
    SHELL
       )
    run(<<-SHELL
      ffmpeg -i #{stitched_filepath} #{edit_filepath}
    SHELL
       )
  end
end
