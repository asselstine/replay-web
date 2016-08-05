class CreateSegmentEfforts < ActiveRecord::Migration
  def change
    create_table :segment_efforts do |t|
      t.integer :strava_segment_effort_id, null: false, unique: true, limit: 8
      t.string :name, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :elapsed_time, null: false, limit: 8
      t.integer :moving_time, null: false, limit: 8
      t.integer :start_index, null: false, limit: 8
      t.integer :end_index, null: false, limit: 8
      t.integer :kom_rank, limit: 8
      t.integer :pr_rank, limit: 8
      t.references :activity
      t.references :segment
    end
  end
end
