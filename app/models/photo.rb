class Photo < ActiveRecord::Base
  TIME_MARGIN_OF_ERROR = 1
  DEFAULT_RANGE_M = 15

  belongs_to :user
  has_many :setup_photos
  has_many :setups, through: :setup_photos
  mount_uploader :image, PhotoUploader

  validates_presence_of :source_url, if: (proc do |photo|
    photo.image.blank?
  end)
  validates_presence_of :image, if: proc { |photo| photo.source_url.blank? }
  validates_presence_of :user

  after_save :check_source_url

  scope :during, (lambda do |start_at, end_at|
    where('photos.timestamp >= ?', start_at)
      .where('photos.timestamp <= ?', end_at)
  end)

  private

  def check_source_url
    return unless source_url.present? && source_url_changed?
    UpdatePhotoFileJob.perform_later(photo: self)
  end
end
