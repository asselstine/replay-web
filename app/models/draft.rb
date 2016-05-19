class Draft < ActiveRecord::Base
  belongs_to :setup
  belongs_to :activity
  belongs_to :upload

  validates_presence_of :setup, :activity, :upload
end
