class SegmentEffort < ActiveRecord::Base
  belongs_to :activity
  belongs_to :segment

  scope :at, (lambda do |at|
    where('segment_efforts.start_at <= ?', at)
      .where('segment_efforts.end_at >= ?', at)
  end)

  scope :during, (lambda do |start_at, end_at|
    query = <<-SQL
      (segment_efforts.start_at, segment_efforts.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order(start_at: :asc)
  end)
end
