class AddOutputTypeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :output_type, :integer
  end
end
