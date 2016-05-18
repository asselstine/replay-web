class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1
  DEFAULT_RANGE_M = 15

  belongs_to :user
  has_many :setup_photos
  has_many :setups, through: :setup_photos
  mount_uploader :image, PhotoUploader

  validates_presence_of :image
  validates_presence_of :user

  scope :during, (lambda do |start_at, end_at|
    where('photos.timestamp >= ?', start_at)
      .where('photos.timestamp <= ?', end_at)
  end)
end
