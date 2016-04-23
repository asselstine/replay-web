# rubocop:disable Style/ClassAndModuleChildren
class Edit::VideoProcessor < Edit::Processor
  protected

  def process(comparator)
    frame_start_at = draft_start_at(comparator)
    frame_end_at = draft_end_at(comparator)
    if continue_current_draft(comparator, frame_start_at)
      @drafts.last.end_at = frame_end_at
    else
      @drafts << Draft.new(activity: comparator.activity,
                           setup: comparator.setup,
                           upload: comparator.upload,
                           start_at: frame_start_at,
                           end_at: frame_end_at)
    end
    frame_end_at
  end

  def draft_start_at(comparator)
    [@frame.start_at, comparator.upload.start_at].max
  end

  def draft_end_at(comparator)
    [@frame.end_at, comparator.upload.end_at].min
  end

  def continue_current_draft(comparator, start_at)
    @drafts.any? &&
      @drafts.last.upload == comparator.upload &&
      @drafts.last.end_at == start_at
  end
end
