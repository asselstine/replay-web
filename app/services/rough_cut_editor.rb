class RoughCutEditor
  include Service
  include Virtus.model

  attribute :activity
  attribute :process, Boolean, default: true

  def call
    @frame = Frame.new(start_at: activity.start_at, end_at: activity.end_at)
    build_edits
    @current_cut.save if @current_cut
    do_process if process
  end

  protected

  def do_process
    activity.edits.each do |edit|
      EditProcessorJob.perform_later(edit: edit)
    end
  end

  def build_edits
    loop do
      video = edit_evaluator.find_best_video
      create_new_edit(video) unless video.nil? || current_edit_continue(video)
      break unless @frame.next!
    end
  end

  def create_new_edit(video)
    @current_cut.save if @current_cut
    edit = activity.edits.create(user: activity.user)
    @current_cut = edit.cuts.build(video: video,
                                   start_at: @frame.start_at,
                                   end_at: @frame.end_at
                                  )
  end

  def current_edit_continue(video)
    return false unless @current_cut &&
                        @current_cut.video == video &&
                        @current_cut.end_at == @frame.start_at
    @current_cut.end_at = @frame.end_at
    true
  end

  def edit_evaluator
    @edit_evaluator ||= EditEvaluator.new(user_evaluator: activity_evaluator,
                                          frame: @frame)
  end

  def activity_evaluator
    @activity_evaluator ||= ActivityEvaluator.new(frame: @frame,
                                                  activity: activity)
  end
end
