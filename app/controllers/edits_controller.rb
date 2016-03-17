class EditsController < ApplicationController
  before_action :find_edit, only: [:reprocess, :recut]

  def reprocess
    EditProcessorJob.perform_later(edit: @edit)
    redirect_to feed_path
  end

  def recut
    @edit.cuts.destroy_all
    Editor.call(edit: @edit)
    redirect_to feed_path
  end

  protected

  def find_edit
    @edit = Edit.find(params[:id])
  end
end
