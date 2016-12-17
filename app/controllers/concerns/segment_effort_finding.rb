module SegmentEffortFinding
  extend ActiveSupport::Concern

  included do
    def find_segment_effort
      @segment_effort =
        SegmentEffort.find(params[:segment_effort_id] || params[:id])
    end
  end
end
