class CreateEdit < ActiveRecord::Migration
  def change
    create_table :edits do |t|
      t.references :user

      t.timestamps
    end
  end
end
