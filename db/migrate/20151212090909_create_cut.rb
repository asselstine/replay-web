class CreateCut < ActiveRecord::Migration
  def change
    create_table :cuts do |t|
      t.references :edit
      t.references :video
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
