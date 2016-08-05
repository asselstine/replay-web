module Edit
  class ActivityVideoStrategy < VideoDraftingStrategy
    # frame, comparator, draft
    def continue_draft?(frame, comparator, draft)
      return false unless draft &&
                          draft.source_video == comparator.video &&
                          draft.end_at == activity_video_start_at(frame,
                                                                  comparator)
      draft.end_at = activity_video_end_at(frame, comparator)
      true
    end

    # frame, comparator
    def new_draft(frame, comparator)
      VideoDraft.new(activity: comparator.activity,
                     setup: comparator.setup,
                     source_video: comparator.video,
                     start_at: activity_video_start_at(frame, comparator),
                     end_at: activity_video_end_at(frame, comparator),
                     name: comparator.activity.strava_name)
    end

    def activity_video_start_at(frame, comparator)
      [draft_start_at(frame, comparator), comparator.activity.start_at].max
    end

    def activity_video_end_at(frame, comparator)
      [draft_end_at(frame, comparator), comparator.activity.end_at].min
    end
  end
end
