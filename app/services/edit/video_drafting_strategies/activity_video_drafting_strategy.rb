# # Turns out SegmentEffortVideoStrategy was not needed- drafts are simply about
# # portions of video uploads that are good candidates for the user's feed.
# module Edit
#   module VideoDraftingStrategies
#     class ActivityVideoStrategy < VideoDraftingStrategy
#       def continue_draft?(frame, comparator, draft)
#         continuing = draft &&
#                      draft.source_video == comparator.video &&
#                      draft.end_at == effort_video_start_at(frame, comparator) &&
#                      draft.activity == comparator.activity
#         return false unless continuing
#         # Rails.logger.debug("Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy: continuing_draft #{draft.id} for frame #{frame}")
#         draft.end_at = effort_video_end_at(frame, comparator)
#         true
#       end
#
#       def new_draft(frame, comparator)
#         # Rails.logger.debug("Edit::VideoDraftingStrategies::SegmentEffortVideoStrategy: new_draft #{frame}")
#         VideoDraft.new(activity: comparator.activity,
#                        setup: comparator.setup,
#                        source_video: comparator.video,
#                        start_at: effort_video_start_at(frame, comparator),
#                        end_at: effort_video_end_at(frame, comparator),
#                        name: comparator.activity.name)
#       end
#
#       def effort_video_start_at(frame, comparator)
#         [
#           draft_start_at(frame, comparator),
#           comparator.activity.start_at
#         ].max
#       end
#
#       def effort_video_end_at(frame, comparator)
#         [
#           draft_end_at(frame, comparator),
#           comparator.activity.end_at
#         ].min
#       end
#     end
#   end
# end
