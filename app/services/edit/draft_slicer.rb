# rubocop:disable Style/ClassAndModuleChildren
class Edit::DraftSlicer
  include Service
  include Virtus.model

  attribute :draft

  def call
    draft.create_video!(file: File.open(slice_upload))
    draft.save!
  end

  def slice_upload
    FFMPEG::Slice.call(
      video: draft.upload.video,
      start_at: draft.start_at,
      end_at: draft.end_at,
      video_start_at: draft.upload.start_at)
  end
end
