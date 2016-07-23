class SegmentEffort < ActiveRecord::Base
  belongs_to :activity
  belongs_to :segment

  scope :during, (lambda do |at|
    where('segment_efforts.start_at <= ?', at)
      .where('segment_efforts.end_at >= ?', at)
  end)
end
