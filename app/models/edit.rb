class Edit < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  has_many :cuts
  has_many :videos, through: :cuts
  has_many :final_cuts

  after_create :cut_edit

  accepts_nested_attributes_for :cuts

  def build_cuts(start_at, end_at)
    context = Context.new(start_at: start_at,
                          end_at: end_at)
    loop do
      video = find_best_video(context)
      cuts.build(start_at: context.cut_start_at,
                 end_at: context.cut_end_at,
                 video: video) if video
      break unless context.next!
    end
  end

  protected

  def find_best_video(context)
    camera = find_best_camera(context)
    camera.videos.containing(context.cut_start_at,
                             context.cut_end_at).first if camera
  end

  def find_best_camera(context)
    user_eval = user.evaluator(context)
    cameras = Camera.with_video_containing(context.cut_start_at,
                                           context.cut_end_at)
    camera_evals = cameras.map { |cam| cam.evaluator(context) }
    camera_evals.sort do |b, a|
      a.strength(user_eval) <=> b.strength(user_eval)
    end.first.try(:camera)
  end

  def cut_edit
    CutEditJob.perform_later(video_edit: self) unless Rails.env.test?
  end
end
