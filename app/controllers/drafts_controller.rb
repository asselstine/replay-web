class DraftsController < LoggedInController
  before_action :find_draft, only: [:show]

  def index
    @drafts = current_user.drafts.photo_or_video_exists
  end

  def show
  end

  protected

  def find_draft
    @draft = Draft.find(params[:id])
  end
end
