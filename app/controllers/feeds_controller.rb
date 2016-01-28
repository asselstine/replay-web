class FeedsController < ApplicationController
  def show
    StravaDataSync.call(user: current_user)
    GenerateEdits.call(user: current_user)
    @photos = current_user.feed_photos
    @edits = current_user.edits
  end
end
