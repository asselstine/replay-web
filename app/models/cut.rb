class Cut < ActiveRecord::Base
  belongs_to :edit
  belongs_to :video
  validates :start_at, :end_at, presence: true

  def self.ending_at(end_at)
    where(end_at: end_at)
  end

  def self.during(start_at, end_at)
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at)
  end
end
