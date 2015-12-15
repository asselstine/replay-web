class Camera < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.references :user
      t.decimal :range_m
      t.timestamps
    end
  end
end
