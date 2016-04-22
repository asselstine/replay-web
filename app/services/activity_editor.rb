class ActivityEditor
  include Virtus.model
  include Service

  attribute :setup_selector
  attribute :start_at
  attribute :end_at
  attribute :frame_size, ActiveSupport::Duration, default: 1.second

  def call
    @drafts = []
    @frame = Frame.new(start_at: start_at, end_at: start_at + frame_size)
    build_drafts
    @drafts
  end

  # def self.setup_selector
  #   @setup_video_selector ||= SetupVideoSelector.new(activity: activity,
  #                                                    setups: setups)
  # end
  #
  # def self.setups
  #   @setups ||= Setup.with_video_during(activity.start_at, activity.end_at)
  # end

  protected

  def build_drafts
    while @frame.start_at < end_at
      comparator = setup_selector.find_best_setup(@frame)
      frame_end_at = if comparator
                       process(comparator)
                     else
                       @frame.end_at
                     end
      @frame.start_at = frame_end_at
      @frame.end_at = frame_end_at + frame_size
    end
  end

  def process(comparator)
    frame_start_at = draft_start_at(comparator)
    frame_end_at = draft_end_at(comparator)
    if continue_current_cut(comparator, frame_start_at)
      @drafts.last.end_at = frame_end_at
    else
      @drafts << Draft.new(activity: comparator.activity,
                           setup: comparator.setup,
                           upload: comparator.upload,
                           start_at: frame_start_at,
                           end_at: frame_end_at)
    end
    frame_end_at
  end

  def draft_start_at(comparator)
    [@frame.start_at, comparator.upload.start_at].max
  end

  def draft_end_at(comparator)
    [@frame.end_at, comparator.upload.end_at].min
  end

  def continue_current_cut(comparator, start_at)
    @drafts.any? &&
      @drafts.last.upload == comparator.upload &&
      @drafts.last.end_at == start_at
  end
end
