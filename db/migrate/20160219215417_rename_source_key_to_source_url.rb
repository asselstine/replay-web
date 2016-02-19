class RenameSourceKeyToSourceUrl < ActiveRecord::Migration
  def change
    rename_column :videos, :source_key, :source_url
  end
end
