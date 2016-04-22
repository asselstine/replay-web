class EditEvaluator < Evaluator
  include Virtus.model

  attribute :user_evaluator

  def find_best_video
    filtered = compute_strength_map.select do |strength|
      strength[:strength] > 0
    end
    strongest = filtered.sort do |strength1, strength2|
      strength2[:strength] <=> strength1[:strength]
    end.first
    strongest[:video_evaluator].video if strongest
  end

  protected

  def compute_strength_map
    video_evaluators.map do |video_evaluator|
      {
        strength: video_evaluator.strength(user_evaluator),
        video_evaluator: video_evaluator
      }
    end
  end

  def video_evaluators
    @video_evaluators ||= videos.map do |video|
      VideoEvaluator.new(video: video, frame: frame)
    end
  end

  # assuming the frame start and end do not change.
  def videos
    @videos ||= Video.during(frame.activity.start_at, frame.activity.end_at)
  end
end
