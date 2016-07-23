class AddSegmentEffortToVideoDraft < ActiveRecord::Migration
  def change
    add_column :drafts, :segment_effort_id, :integer, index: true
  end
end
