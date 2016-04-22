class SetupPhoto < ActiveRecord::Base
  belongs_to :photo
  belongs_to :setup
end
