class SetupVideoComparator
  include Comparable
  include Virtus.model

  attribute :setup, Setup
  attribute :activity, Activity
  attribute :frame, Frame

  attr_accessor :strength
  attr_accessor :video

  def <=>(other)
    strength <=> other.strength
  end

  def compute_strength(frame)
    @strength = if video_during_frame?(frame)
                  distance_strength(frame)
                else
                  0
                end
  end

  protected

  def video_during_frame?(frame)
    @video = setup.videos.during(frame.start_at, frame.end_at).first
    @video.present?
  end

  def distance_strength
    Geo.distance_strength(setup.coords,
                          activity.coords_at(frame.start_at))
  end
end
