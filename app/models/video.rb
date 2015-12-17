class Video < ActiveRecord::Base 
  belongs_to :camera, inverse_of: :videos

  def self.during(start_at, end_at)
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order('start_at ASC')
  end

  def self.containing(start_at, end_at)
    where('start_at <= ? AND end_at >= ?', start_at, end_at)
  end
end
