class Evaluator
  include Virtus.model
  attribute :frame, Frame

  def now
    frame.cut_start_at
  end
end
