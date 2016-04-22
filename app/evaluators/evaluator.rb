class Evaluator
  include Virtus.model
  attribute :frame, Frame

  def now
    frame.start_at
  end
end
