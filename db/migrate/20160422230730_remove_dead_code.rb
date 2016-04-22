class RemoveDeadCode < ActiveRecord::Migration
  def change
    drop_table :final_cuts
    drop_table :edits
    drop_table :recording_sessions
    drop_table :cuts
    drop_table :locations
  end
end
