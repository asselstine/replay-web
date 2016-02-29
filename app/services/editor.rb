class Editor
  include Service
  include Virtus.model

  attribute :user
  attribute :ride

  def call
    edit = Edit.new(user: user, ride: ride)
    build_cuts(edit, ride.start_at, ride.end_at)
    edit.save
    process(edit) if edit.persisted?
    edit
  end

  protected

  def build_cuts(edit, start_at, end_at)
    frame = Frame.new(start_at: start_at,
                      end_at: end_at)
    edit_eval = EditEvaluator.new(user: user, frame: frame)
    loop do
      video = edit_eval.find_best_video
      edit.cuts.build(start_at: frame.cut_start_at,
                      end_at: frame.cut_end_at,
                      video: video) if video
      break unless frame.next!
    end
  end

  def process(edit)
    Rails.logger.debug("generate_edit: process(#{edit.id})")
    EditProcessorJob.perform_later(edit: edit) unless Rails.env.test?
  end
end
