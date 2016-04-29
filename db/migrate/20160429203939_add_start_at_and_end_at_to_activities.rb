class AddStartAtAndEndAtToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
