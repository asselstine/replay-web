class ActivitiesController < LoggedInController
  before_action :find_activity, only: [:show, :recut]

  def index
    @activities = current_user.activities
  end

  def show; end

  def recut
    redirect_to @activity
  end

  protected

  def find_activity
    @activity = Activity.find(params[:id])
  end
end
