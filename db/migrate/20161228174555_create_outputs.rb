class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.references :job, foreign_key: true, index: true, null: false
      t.integer :media_type, null: false, default: 0
      t.integer :segment_duration
      t.string :key, null: false
      t.string :preset_id, null: false
    end
  end
end
