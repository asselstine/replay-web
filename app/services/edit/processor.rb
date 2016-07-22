# rubocop:disable Style/ClassAndModuleChildren
class Edit::Processor
  include Virtus.model
  include Service

  attribute :start_at
  attribute :end_at
  attribute :frame_size, ActiveSupport::Duration, default: 1.second

  def call
    @drafts = []
    process_frames
    @drafts
  end

  protected

  def process_frames
    @frame = Edit::Frame.new(start_at: start_at, end_at: start_at + frame_size)
    while @frame.start_at < end_at
      frame_end_at = process(@frame)
      @frame.start_at = frame_end_at
      @frame.end_at = frame_end_at + frame_size
    end
  end

  def process(_)
    raise 'process(frame) -> frame end time. You must implement this method'
  end
end
