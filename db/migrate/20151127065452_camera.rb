class Camera < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.references :user
      t.decimal :range_m, default: 10
      t.timestamps
    end
  end
end
