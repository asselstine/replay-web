# Updates an edit with cuts from any valid video; stitching together the result.
class MultiVideoEditor
  include Service
  include Virtus.model

  attribute :edit

  def call
    @frame = Frame.new(start_at: edit.start_at, end_at: edit.end_at)
    build_cuts
    edit.save
    process(edit) if edit.persisted?
    edit
  end

  protected

  def build_cuts
    edit_eval = EditEvaluator.new(user_evaluator: user_evaluator, frame: @frame)
    loop do
      video = edit_eval.find_best_video
      edit.cuts.build(start_at: @frame.cut_start_at,
                      end_at: @frame.cut_end_at,
                      video: video) if video
      break unless @frame.next!
    end
  end

  def process(edit)
    Rails.logger.debug("generate_edit: process(#{edit.id})")
    EditProcessorJob.perform_later(edit: edit) unless Rails.env.test?
  end

  def user_evaluator
    @user_evaluator ||= UserEvaluator.new(user: edit.user, frame: @frame)
  end
end
