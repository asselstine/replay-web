class Draft < ActiveRecord::Base
  belongs_to :setup
  belongs_to :activity
  belongs_to :upload
end
