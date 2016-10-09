class ExploreController < ApplicationController
  def index
    @video_drafts = VideoDraft.all
  end
end
