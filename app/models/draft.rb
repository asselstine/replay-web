class Draft < ActiveRecord::Base
  belongs_to :setup
  belongs_to :activity
  belongs_to :video

  has_one :user, through: :activity

  validates_presence_of :setup, :activity

  scope :photo_or_video_exists, (lambda do
    table = arel_table
    where(table[:photo_id].not_eq(nil).or(table[:video_id].not_eq(nil)))
  end)

  def latitudes
    timeseries(activity.latitudes)
  end

  def longitudes
    timeseries(activity.longitudes)
  end

  private

  def timeseries(array)
    start_index = activity.timeseries_index_at(start_at)
    end_index = activity.timeseries_index_at(end_at)
    return [] unless start_index && end_index
    array[start_index, end_index - start_index + 1]
  end
end
