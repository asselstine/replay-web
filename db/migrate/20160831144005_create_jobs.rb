class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :status, default: 0, null: false
      t.string :message
      t.string :external_id
      t.datetime :started_at
      t.datetime :finished_at

      t.references :video
      t.integer :rotation, default: 0, null: false
      t.string :key

      t.timestamps null: false
    end
  end
end
