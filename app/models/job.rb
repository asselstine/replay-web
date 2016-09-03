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

  validates :video, :rotation, presence: true

  after_create :create_playlist

  private

  def create_playlist
    HlsJobs::CreatePlaylist.call(job: self)
  end
end
