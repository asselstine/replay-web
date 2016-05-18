class RefactorDraftsToBePolymorphic < ActiveRecord::Migration
  def change
    change_table :drafts do |t|
      t.string :type
      t.references :photo, index: true, foreign_key: true
    end
    remove_column :drafts, :upload_id, :integer
  end
end
