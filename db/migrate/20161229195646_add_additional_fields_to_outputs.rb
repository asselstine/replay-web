class AddAdditionalFieldsToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :thumbnail_interval_s, :integer
    add_column :outputs, :thumbnail_pattern, :string
    add_column :outputs, :thumbnail_format, :string
    add_column :outputs, :duration_millis, :integer
    add_column :outputs, :width, :integer
    add_column :outputs, :height, :integer
    add_column :outputs, :file_size, :integer
  end
end
