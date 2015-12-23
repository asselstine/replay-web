class Edit < ActiveRecord::Base
  belongs_to :user
  has_many :cuts
  has_many :videos, through: :cuts

  class Context
    include Virtus.model

    attribute :start_at
    attribute :end_at
    attribute :cut_start_at
    attribute :cut_end_at

    attribute :user_locations

    def user_coords_at(time)
      @lat_spline ||= Location.lat_spline(user_locations)
      @long_spline ||= Location.long_spline(user_locations)
      time_ms = (time.to_f*1000).to_i
      [@lat_spline.eval(time_ms), @long_spline.eval(time_ms)]
    end

    def user_coords_at_cut
      user_coords_at(cut_start_at)
    end
  end

  def build_cuts(start_at, end_at)
    context = Context.new(start_at: start_at,
                          end_at: end_at)
    context.cut_start_at = start_at
    context.user_locations = user.locations.during(start_at, end_at)
    while(context.cut_start_at < context.end_at)
      context.cut_end_at = context.cut_start_at + 1.second
      # puts "#build_cuts: start_at: #{start_at} current_end_at: #{current_end_at}"
      video = find_best_video(context)
      cuts.build(start_at: context.cut_start_at, end_at: context.cut_end_at, video: video) if video
      context.cut_start_at = context.cut_end_at
    end
  end 

  protected 

  def find_best_video(context)
    cameras = Camera.with_video_containing(context.cut_start_at, context.cut_end_at)
    camera = Camera.sort_by_strength(cameras, context).first
    camera.videos.containing(context.cut_start_at, context.cut_end_at).first if camera
  end
end
