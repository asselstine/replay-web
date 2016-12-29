class Job < ActiveRecord::Base
  belongs_to :video
  belongs_to :playlist, dependent: :destroy
  has_many :outputs, dependent: :destroy
  has_one :upload, through: :video

  enum output_type: {
    hls: 0,
    web: 1
  }

  enum status: {
    created: 0,
    submitted: 1,
    progressing: 2,
    canceled: 3,
    error: 4,
    complete: 5
  }

  enum rotation: {
    rotate_auto: -1,
    rotate_0: 0,
    rotate_90: 90,
    rotate_180: 180,
    rotate_270: 270
  }

  scope :incomplete, -> { where.not(status: Job.statuses[:complete]) }

  delegate :source_key, to: :video

  validates :video, :rotation, presence: true

  after_destroy :remove_s3_objects

  def output_for_key(key)
    outputs.where(key: key).first
  end

  def full_key(key)
    "#{prefix}#{key}"
  end

  def prefix
    "jobs/job-#{id}-#{created_at.to_i}/"
  end

  def playlist_filename
    "#{video.source_filename_no_ext}.m3u8"
  end

  def playlist_key
    full_key(playlist_filename)
  end

  def rotate_elastic_transcoder_format
    return 'auto' if rotate_auto?
    self.class.rotations[rotation].to_s
  end

  private

  def remove_s3_objects
    S3.object(prefix).delete
  end
end
