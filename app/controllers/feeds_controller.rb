class FeedsController < ApplicationController
  def show
    StravaDataSync.call(user: current_user)
    GenerateEdits.call(user: current_user)
    @edits = current_user.edits
  end
end
