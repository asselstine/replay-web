# rubocop:disable Style/ClassAndModuleChildren
class Edit::DraftSlicer
  include Service
  include Virtus.model

  attribute :draft

  def call
    draft.create_video!(file: File.open(slice_upload),
                        user: draft.user)
    FFMPEG::Thumbnail.call(video: draft.video)
    draft.save!
  end

  def slice_upload
    FFMPEG::Slice.call(
      video: draft.source_video,
      start_at: draft.start_at,
      end_at: draft.end_at
    )
  end
end
