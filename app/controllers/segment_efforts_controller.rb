class SegmentEffortsController < LoggedInController
  before_action :find_and_authorize_segment_effort

  def drafts
    render json: @segment_effort.drafts
  end

  private

  def find_and_authorize_segment_effort
    @segment_effort = SegmentEffort.find(params[:id])
    authorize @segment_effort
  end
end
