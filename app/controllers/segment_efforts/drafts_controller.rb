module SegmentEfforts
  class DraftsController < LoggedInController
    before_action :find_segment_effort
    before_action :find_draft

    def show
    end
  end
end
