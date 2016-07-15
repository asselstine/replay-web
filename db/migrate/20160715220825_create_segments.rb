class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.integer :strava_segment_id, null: false, unique: true, limit: 8
      t.string :name
      t.string :activity_type
      t.decimal :distance
      t.decimal :average_grade
      t.decimal :maximum_grade
      t.decimal :elevation_high
      t.decimal :elevation_low
      t.string :city
      t.string :state
      t.string :country
      t.boolean :is_private
    end
  end
end
