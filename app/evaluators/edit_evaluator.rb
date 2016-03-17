class EditEvaluator
  include Virtus.model

  attribute :user_evaluator
  attribute :frame, Frame

  def find_best_video
    camera = find_best_camera
    camera.videos.containing(frame.cut_start_at,
                             frame.cut_end_at).first if camera
  end

  def find_best_camera
    camera_evals.sort do |b, a|
      a.strength(user_evaluator) <=> b.strength(user_evaluator)
    end.first.try(:camera)
  end

  def frame_cameras
    cameras.with_video_containing(frame.cut_start_at, frame.cut_end_at)
  end

  def camera_evals
    frame_cameras.map { |cam| cam.evaluator(frame) }
  end

  def cameras
    @cameras ||= Camera.with_video_during(frame.start_at, frame.end_at)
  end
end