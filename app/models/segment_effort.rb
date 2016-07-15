class SegmentEffort < ActiveRecord::Base
  belongs_to :activity
  belongs_to :segment
end
