class DraftPhoto < ActiveRecord::Base
  belongs_to :activity
  belongs_to :photo
end
