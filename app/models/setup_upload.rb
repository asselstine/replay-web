class SetupUpload < ActiveRecord::Base
  belongs_to :upload
  belongs_to :setup
end
