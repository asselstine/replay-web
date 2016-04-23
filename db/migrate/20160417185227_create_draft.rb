class CreateDraft < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.references :video
      t.references :setup
      t.references :activity
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
