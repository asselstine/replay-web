class Video < ActiveRecord::Base 
  belongs_to :camera, inverse_of: :videos

  def self.during(start_at, end_at)
    query = <<-SQL
      (videos.start_at, videos.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order('start_at ASC')
  end

  def self.inbetween?(s1, e1, s2, e2)
    (e2 - s1 > 0 && (e2 - s1 < (e1-s1) + (e2-s2))) ||
      (e1 - s2 > 0 && (e1 - s2 < (e2-s2) + (e1-s1)))
  end
end
