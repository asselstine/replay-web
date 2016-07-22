module FrameHelpers
  def f(start_at, end_at)
    start_at = t(start_at) if start_at.is_a? Integer
    end_at = t(end_at) if end_at.is_a? Integer
    Edit::Frame.new(start_at: start_at, end_at: end_at)
  end
end
