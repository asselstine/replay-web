# Represents an individual file upload.  The upload references the original
# Video and the Camera it belongs to.
class Upload < ActiveRecord::Base
  has_many :setup_uploads, inverse_of: :upload
  has_many :setups, through: :setup_uploads
  has_many :drafts, inverse_of: :upload
  belongs_to :video
  has_many :jobs, through: :video

  accepts_nested_attributes_for :setups

  belongs_to :user
  validates_presence_of :user

  scope :video, -> { where(type: 'VideoUpload') }
  scope :photo, -> { where(type: 'PhotoUpload') }
  scope :complete, -> { joins(video: :jobs).merge(Job.complete) }

  after_create :process_upload, unless: 'processed?'

  def process_upload
    ProcessUploadJob.perform_later(upload: self)
  end

  private

  def processed?
    process_msg.present? || type != 'Upload'
  end
end
