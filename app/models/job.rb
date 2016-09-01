class Job < ActiveRecord::Base
  belongs_to :video
  has_many :playlists

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

  validates :video, presence: true

  after_create :create_et_job

  private

  def create_et_job
    HlsJob::Create.call(job: self)
  end
end
