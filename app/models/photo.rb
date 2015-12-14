class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1

  belongs_to :user
  belongs_to :camera
  mount_uploader :image, PhotoUploader

  def self.at(datetime)
    where('timestamp < ?', datetime.since(TIME_MARGIN_OF_ERROR))
      .where('timestamp >= ?', datetime.ago(TIME_MARGIN_OF_ERROR))
  end
end
