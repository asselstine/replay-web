class Edit < ActiveRecord::Base
  belongs_to :user
  has_many :cuts, -> { order(start_at: :asc) }
  has_many :videos, through: :cuts

  def build_cuts(start_at, end_at)
    location = user.location_at(start_at)
    cameras = Camera.find_video_candidates(location, start_at, end_at)
    camera = Camera.sort_by_strength(cameras, start_at, user).first
    cuts = []
    return cuts unless camera
    next_start_at = start_at
    camera.videos.during(start_at, end_at).each do |video|
      cut_start_at = [start_at,video.start_at].max
      cut_end_at = [video.end_at, end_at].min 
      cut = build_cut(cut_start_at, cut_end_at, video)
      next_start_at = cut_end_at 
      cuts << cut
    end
    cuts
  end 

  protected 

  def previous_cut(time)
    cuts.sort { |a,b| a.end_at <=> b.end_at }
        .select do |a|
          a.end_at <= time &&
            time.to_i - a.end_at.to_i < 1000
        end
        .last
  end
  
  def build_cut(start_at, end_at, video)
    previous = previous_cut(start_at) 
    if  previous && 
        previous.video_id == video.id
      previous.end_at = end_at
      cut = previous 
    else
      cut = cuts.build(start_at: start_at, 
                      end_at: end_at, 
                      video: video) 
    end
    cut
  end
end
