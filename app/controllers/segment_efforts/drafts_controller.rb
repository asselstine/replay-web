module SegmentEfforts
  class DraftsController < LoggedInController
    include ApplicationHelper
    include SegmentEffortFinding

    before_action :find_segment_effort

    def index
      render json: serialize_to_json(@segment_effort.drafts)
    end
  end
end
