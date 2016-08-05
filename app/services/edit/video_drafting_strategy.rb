module Edit
  class VideoDraftingStrategy
    def draft_start_at(frame, comparator)
      [frame.start_at, comparator.video.start_at].max
    end

    def draft_end_at(frame, comparator)
      [frame.end_at, comparator.video.end_at].min
    end

    # frame, comparator, draft
    def continue_draft?(_, _, _)
      raise NotImplementedError
    end

    # frame, comparator
    def new_draft(_, _)
      raise NotImplementedError
    end
  end
end
