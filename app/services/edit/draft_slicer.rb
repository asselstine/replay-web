# rubocop:disable Style/ClassAndModuleChildren
class Edit::DraftSlicer
  include Service
  include Virtus.model

  attribute :draft

  def call
    output_filepath = FFMPEG::VideoSlice.call(video: draft.upload.video,
                                              start_at: draft.start_at,
                                              end_at: draft.end_at)
    draft.video.create!(file: File.open(output_filepath))
  end
end
