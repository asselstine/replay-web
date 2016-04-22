class RemoveVideoFromDraftsAndAddUpload < ActiveRecord::Migration
  def change
    remove_reference :drafts, :video
    add_reference :drafts, :upload
  end
end
