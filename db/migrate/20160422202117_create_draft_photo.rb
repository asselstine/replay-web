class CreateDraftPhoto < ActiveRecord::Migration
  def change
    create_table :draft_photos do |t|
      t.references :photo
      t.references :activity
    end
  end
end
