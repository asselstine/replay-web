# Breaks a time range into Frames to be processed by a FrameProcessor.
module Edit
  class FrameSeries
    include Virtus.model
    include Service

    attribute :start_at
    attribute :end_at
    attribute :frame_size, ActiveSupport::Duration, default: 1.second
    attribute :processor, FrameProcessor

    def call
      Rails.logger.debug("Edit::FrameSeries: Starting #{start_at}, #{end_at}")
      @frame = initial_frame
      while @frame.start_at < end_at
        Rails.logger.debug("Edit::FrameSeries: while #{@frame.start_at}, #{end_at}")
        frame_end_at = processor.process(@frame)
        @frame.start_at = frame_end_at || @frame.end_at
        @frame.end_at = [@frame.start_at + frame_size, end_at].min
      end
    end

    private

    def initial_frame
      Edit::Frame.new(start_at: start_at,
                      end_at: start_at + frame_size)
    end
  end
end
