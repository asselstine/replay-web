class Edit < ActiveRecord::Base
  belongs_to :user
  has_many :cuts
  has_many :videos, through: :cuts

  def build_cuts(start_at, end_at)
    previous_cut = nil
    while(start_at < end_at)
      current_end_at = start_at + 1.second
      video = find_best_video(start_at, current_end_at)
      previous_cut = next_cut(previous_cut, start_at, current_end_at, video) if video
      start_at = current_end_at 
    end
  end 

  protected 

  def next_cut(previous_cut, start_at, end_at, video)
    if previous_cut && 
       previous_cut.video_id == video.id &&
       start_at.to_f - previous_cut.end_at.to_f < 0.01
       previous_cut.end_at = end_at
       next_cut = previous_cut
    else
      next_cut = cuts.build(start_at: start_at, end_at: start_at + 1.second, video: video)
    end
    next_cut
  end

  def find_best_video(start_at, end_at)
    cameras = Camera.with_video_containing(start_at, end_at)
    camera = Camera.sort_by_strength(cameras, start_at, user).first
    camera.videos.containing(start_at, end_at).first
  end

  def build_cut(start_at, end_at)
    return nil unless video
    cuts.build(start_at: start_at, end_at: end_at, video: video)
  end
end
