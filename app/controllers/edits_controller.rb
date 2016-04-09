class EditsController < ApplicationController
  before_action :find_edit, only: [:recut]

  def recut
    RoughCutEditor.call(ride: @edit.ride)
    redirect_to feed_path
  end

  protected

  def find_edit
    @edit = Edit.find(params[:id])
  end
end
