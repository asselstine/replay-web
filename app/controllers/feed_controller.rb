class FeedController < ApplicationController
  def show
    @photos = current_user.feed_photos
  end
end
