class CreateFinalCuts < ActiveRecord::Migration
  def change
    create_table :final_cuts do |t|
      t.references :edit, index: true, foreign_key: true
      t.references :video, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
