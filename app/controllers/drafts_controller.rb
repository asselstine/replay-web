class DraftsController < LoggedInController
  before_action :find_draft, only: [:show]

  def index
    @drafts = current_user.drafts
  end

  def map
    @drafts = Draft.all
  end

  def show; end

  protected

  def find_draft
    @draft = Draft.find(params[:id])
  end
end
