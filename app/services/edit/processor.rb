# rubocop:disable Style/ClassAndModuleChildren
class Edit::Processor
  include Virtus.model
  include Service

  attribute :selector
  attribute :start_at
  attribute :end_at
  attribute :frame_size, ActiveSupport::Duration, default: 1.second

  def call
    @drafts = []
    @frame = Edit::Frame.new(start_at: start_at, end_at: start_at + frame_size)
    process_frames
    @drafts
  end

  protected

  def process_frames
    while @frame.start_at < end_at
      comparator = selector.find_best(@frame)
      frame_end_at = if comparator
                       process(comparator)
                     else
                       @frame.end_at
                     end
      @frame.start_at = frame_end_at
      @frame.end_at = frame_end_at + frame_size
    end
  end

  def process(_)
    fail 'process(comparator) -> frame end time. You must implement this method'
  end
end
