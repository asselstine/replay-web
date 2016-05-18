class RefactorUploadToBePolymorphic < ActiveRecord::Migration
  def change
    change_table :uploads do |t|
      t.string :type, default: 'Upload'
      t.string :url
      t.string :filename
      t.string :unique_id
      t.integer :file_size
      t.string :file_type
      t.string :process_msg
      t.references :photo, index: true, foreign_key: true

      t.timestamps null: false
    end
    remove_column :uploads, :start_at, :datetime
    remove_column :uploads, :end_at, :datetime
    remove_column :videos, :source_url, :string
    remove_column :photos, :source_url, :string
  end
end
