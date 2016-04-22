class EditsController < ApplicationController
  before_action :find_edit, only: [:recut]

  def index
    @edits = @activity.edits
  end

  protected

  def find_edit
    @edit = Edit.find(params[:id])
  end
end
