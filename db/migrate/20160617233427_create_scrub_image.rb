class CreateScrubImage < ActiveRecord::Migration
  def change
    create_table :scrub_images do |t|
      t.references :video
      t.string :image
      t.integer :index
    end
  end
end
