class SegmentEffort < ActiveRecord::Base
  belongs_to :activity
  belongs_to :segment

  before_save :set_start_and_end

  has_many :drafts, (lambda do |segment_effort|
    merge(Draft.during(segment_effort.start_at, segment_effort.end_at))
  end), through: :activity

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

  private

  def set_start_and_end
    self.start_at ||= start_index_time
    self.end_at ||= end_index_time
  end

  def start_index_time
    return unless activity.valid_index? start_index
    activity.start_at + activity.timestamps[start_index].seconds
  end

  def end_index_time
    return unless activity.valid_index? end_index
    activity.start_at + activity.timestamps[end_index].seconds
  end
end
