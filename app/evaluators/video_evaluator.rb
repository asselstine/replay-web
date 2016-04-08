class VideoEvaluator < Evaluator
  attribute :video

  def strength(user_evaluator)
    camera_evaluator.strength(user_evaluator)
  end

  protected

  def camera_evaluator
    @camera_evaluator ||= CameraEvaluator.new(frame: frame,
                                              camera: video.camera)
  end
end
