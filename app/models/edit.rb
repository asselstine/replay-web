class Edit < ActiveRecord::Base
  belongs_to :user
  has_many :cuts
  has_many :videos, through: :cuts

  def build_cuts(start_at, end_at)
    while(start_at < end_at)
      build_cut(start_at, start_at + 1.second)
      start_at += 1.second
    end
  end 

  protected 

  def find_best_video(start_at, end_at)
    cameras = Camera.with_video_containing(start_at, end_at)
    camera = Camera.sort_by_strength(cameras, start_at, user).first
    camera.videos.containing(start_at, end_at).first
  end

  def build_cut(start_at, end_at)
    video = find_best_video(start_at, end_at)
    return unless video
    previous = cuts.where(end_at: start_at, video_id: video.id).first
    if previous
      previous.update(end_at: end_at)
    else
      cuts.create(start_at: start_at, end_at: end_at, video: video)
    end
  end
end
