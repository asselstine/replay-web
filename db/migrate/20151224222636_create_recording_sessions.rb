class CreateRecordingSessions < ActiveRecord::Migration
  def change
    create_table :recording_sessions do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
