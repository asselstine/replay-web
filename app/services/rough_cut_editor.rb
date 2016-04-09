class RoughCutEditor
  include Service
  include Virtus.model

  attribute :ride

  def call
    ride.edits.destroy_all # destroy old edits
    @frame = Frame.new(start_at: ride.start_at, end_at: ride.end_at)
    build_edits
  end

  protected

  def build_edits
    loop do
      video = edit_evaluator.find_best_video
      create_new_edit(video) unless video.nil? || current_edit_continue(video)
      break unless @frame.next!
    end
  end

  def create_new_edit(video)
    edit = ride.edits.create(user: ride.user)
    @current_cut = edit.cuts.create(video: video,
                                    start_at: @frame.cut_start_at,
                                    end_at: @frame.cut_end_at
                                   )
  end

  def current_edit_continue(video)
    return false unless @current_cut &&
                        @current_cut.video == video &&
                        @current_cut.end_at == @frame.cut_start_at
    @current_cut.end_at = @frame.cut_end_at
    true
  end

  def edit_evaluator
    @edit_evaluator ||= EditEvaluator.new(user_evaluator: ride_evaluator,
                                          frame: @frame)
  end

  def ride_evaluator
    @ride_evaluator ||= RideEvaluator.new(frame: @frame, ride: ride)
  end
end
