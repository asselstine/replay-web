class FeedsController < ApplicationController
  def show
    @edits = current_user.edits
  end
end
