class EditsController < ApplicationController
  before_action :find_edit, only: [:reprocess]

  def reprocess
    EditProcessorJob.perform_later(edit: @edit)
    redirect_to feed_path
  end

  def recut
    @edit.cuts.destroy_all
    Editor.call(edit: @edit)
  end

  protected

  def find_edit
    @edit = Edit.find(params[:id])
  end
end
