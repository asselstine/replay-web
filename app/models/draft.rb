class Draft < ActiveRecord::Base
  belongs_to :setup
  belongs_to :activity
  belongs_to :upload

  validates_presence_of :setup, :activity, :upload

  scope :photo_or_video_exists, (lambda do
    table = arel_table
    where(table[:photo_id].not_eq(nil).or(table[:video_id].not_eq(nil)))
  end)
end
