# Represents an individual file upload.  The upload references the original
# Video and the Camera it belongs to.
class Upload < ActiveRecord::Base
  has_many :setup_uploads
  has_many :setups, through: :setup_uploads
  accepts_nested_attributes_for :setups

  belongs_to :user
  validates_presence_of :user

  scope :video, -> { where(type: 'VideoUpload') }
  scope :photo, -> { where(type: 'PhotoUpload') }

  after_create :process_upload

  def process_upload
    ProcessUploadJob.perform_later(upload: self)
  end
end
