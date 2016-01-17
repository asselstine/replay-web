class AddEtDataToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.string 'filename'
      t.string 'webm_url'
      t.string 'mp4_url'
      t.string 'status'
      t.string 'message'
      t.string 'job_id' 
      t.integer 'duration_ms'
    end
    rename_column :videos, :source, :source_key
  end
end
