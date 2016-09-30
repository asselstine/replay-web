module Edit
  class Comparator
    include Comparable
    include Virtus.model

    # Input attributes
    attribute :setup, Setup
    attribute :activity, Activity
    attribute :cache_start_at
    attribute :cache_end_at

    # Output attributes
    attribute :strength, BigDecimal

    def <=>(other)
      strength <=> other.strength
    end

    def compute_strength(frame)
      @strength = distance_strength(frame)
    end

    protected

    def distance_strength(frame)
      setup_coords = setup_coords(frame)
      activity_coords = activity.coords_at(frame.start_at)
      return 0 unless setup_coords && activity_coords
      Geo.distance_strength(setup_coords,
                            activity_coords,
                            setup.range_m)
    end

    def setup_coords(frame)
      if setup.strava?
        setup_activity_coords(frame)
      else
        setup.coords
      end
    end

    def setup_activity_coords(frame)
      if cache_start_at && cache_end_at
        cached_activity_coords(frame)
      else
        setup.coords_at(frame)
      end
    end

    def cached_activity_coords(frame)
      chosen = setup_activities.bsearch do |activity|
        activity.start_at <= frame.end_at &&
          activity.end_at > frame.start_at
      end
      chosen.coords_at(frame.start_at) if chosen.present?
    end

    def setup_activities
      @setup_activities ||= setup.user
                                 .activities
                                 .during(cache_start_at, cache_end_at)
                                 .order(start_at: :asc)
    end
  end
end
