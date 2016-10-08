class Job < ActiveRecord::Base
  belongs_to :video
  belongs_to :playlist

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

  delegate :source_key, to: :video

  validates :video, :rotation, presence: true

  after_create :enqueue_transcode_job

  def filename_with_prefix(key)
    "#{prefix}#{key}"
  end

  def prefix
    "hls/job-#{id}/"
  end

  def playlist_filename
    "#{video.source_filename_no_ext}.m3u8"
  end

  def playlist_key
    filename_with_prefix(playlist_filename)
  end

  def rotate_elastic_transcoder_format
    return 'auto' if rotate_auto?
    self.class.rotations[rotation].to_s
  end

  private

  def enqueue_transcode_job
    Jobs::Create.call(job: self)
  end
end
