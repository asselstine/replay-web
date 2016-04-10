class VideoEvaluator < Evaluator
  attribute :video

  def strength(user_evaluator)
    # video must cover entire frame
    return 0 unless video_covers_cut
    camera_evaluator.strength(user_evaluator)
  end

  protected

  def video_covers_cut
    video.start_at <= frame.cut_start_at &&
      video.end_at >= frame.cut_end_at
  end

  def camera_evaluator
    @camera_evaluator ||= CameraEvaluator.new(frame: frame,
                                              camera: video.camera)
  end
end
