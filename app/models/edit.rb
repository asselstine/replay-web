class Edit < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  has_many :cuts
  has_many :videos, through: :cuts

  def build_cuts(start_at, end_at)
    context = Context.new(start_at: start_at,
                          end_at: end_at)
    loop do
      video = find_best_video(context)
      cuts.build(start_at: context.cut_start_at, end_at: context.cut_end_at, video: video) if video
      break unless context.next!
    end
  end 

  def output_key
    "edits/#{id}/output.mp4"
  end

  protected 

  def find_best_video(context)
    user_eval = user.evaluator(context)
    cameras = Camera.with_video_containing(context.cut_start_at, context.cut_end_at)
    camera_evals = cameras.map { |cam| cam.evaluator(context) }
    camera_eval = camera_evals.sort { |b,a| a.strength(user_eval) <=> b.strength(user_eval) }.first 
    camera_eval.camera.videos.containing(context.cut_start_at, context.cut_end_at).first if camera_eval
  end
end
