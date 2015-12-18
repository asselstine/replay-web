class FeedsController < ApplicationController
  def show
    @photos = current_user.feed_photos
    @edits = current_user.edits
  end
end
