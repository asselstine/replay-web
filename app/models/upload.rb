# Represents an individual file upload.  The upload references the original
# Video and the Camera it belongs to.
class Upload < ActiveRecord::Base
  belongs_to :camera
  belongs_to :video

  validates_presence_of :video

  accepts_nested_attributes_for :video

  def self.during(start_at, end_at)
    query = <<-SQL
      (uploads.start_at, uploads.end_at) OVERLAPS (:start_at, :end_at)
    SQL
    where(query, start_at: start_at, end_at: end_at).order(start_at: :asc)
  end
end
