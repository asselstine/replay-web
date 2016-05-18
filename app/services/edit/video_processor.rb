class Edit::VideoProcessor < Edit::Processor
  protected

  def process(comparator)
    frame_start_at = draft_start_at(comparator)
    frame_end_at = draft_end_at(comparator)
    if continue_current_draft(comparator, frame_start_at)
      @drafts.last.end_at = frame_end_at
    else
      @drafts << VideoDraft.new(activity: comparator.activity,
                                setup: comparator.setup,
                                video: comparator.video,
                                start_at: frame_start_at,
                                end_at: frame_end_at)
    end
    frame_end_at
  end

  def draft_start_at(comparator)
    [@frame.start_at, comparator.video.start_at].max
  end

  def draft_end_at(comparator)
    [@frame.end_at, comparator.video.end_at].min
  end

  def continue_current_draft(comparator, start_at)
    @drafts.any? &&
      @drafts.last.video == comparator.video &&
      @drafts.last.end_at == start_at
  end
end
