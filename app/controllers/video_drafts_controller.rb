class VideoDraftsController < LoggedInController
  before_action :find_video_draft

  def show
  end

  protected

  def find_video_draft
    @video_draft = VideoDraft.find(params[:id])
  end
end
