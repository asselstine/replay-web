class Editor
  include Service
  include Virtus.model

  attribute :user
  attribute :ride

  def call
    @edit = ride.edits.build(user: user)
    build_cuts(@edit, start_at, end_at)
    debug("generate_edit(#{ride.id}): number of cuts: #{edit.cuts.length}")
    remote_edit_if_empty(@edit)
  end

  def build_cuts(edit, start_at, end_at)
    context = Context.new(start_at: start_at,
                          end_at: end_at)
    loop do
      video = find_best_video(context)
      edit.cuts.build(start_at: context.cut_start_at,
                      end_at: context.cut_end_at,
                      video: video) if video
      break unless context.next!
    end
  end

  protected

  def remove_edit_if_empty(edit)
    if edit.cuts.empty?
      ride.edits.destroy(edit)
    else
      edit.save
    end
  end

  def find_best_video(context)
    camera = find_best_camera(context)
    camera.videos.containing(context.cut_start_at,
                             context.cut_end_at).first if camera
  end

  def find_best_camera(context)
    user_eval = edit.user.evaluator(context)
    camera_evals = cameras.map { |cam| cam.evaluator(context) }
    camera_evals.sort do |b, a|
      a.strength(user_eval) <=> b.strength(user_eval)
    end.first.try(:camera)
  end

  def cameras
    @cameras ||= Camera.with_video_containing(context.cut_start_at,
                                              context.cut_end_at)
  end

  def cut_edit
    EditProcessorJob.perform_later(video_edit: edit) unless Rails.env.test?
  end
end
