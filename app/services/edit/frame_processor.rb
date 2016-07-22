# Consumes frames using its process method.  The FrameProcessor
# may override the current frame end time by returning a time.
module Edit
  class FrameProcessor
    # Takes the current frame, can optionally return a new frame end time
    def process(_)
      raise 'Not implemented'
    end
  end
end
