module Edit
  class Comparator
    include Comparable
    include Virtus.model

    attribute :setup, Setup
    attribute :activity, Activity
    attribute :strength, BigDecimal

    def <=>(other)
      strength <=> other.strength
    end

    def compute_strength(frame)
      @strength = distance_strength(frame)
    end

    protected

    def distance_strength(frame)
      setup_coords = setup.coords_at(frame.start_at)
      activity_coords = activity.coords_at(frame.start_at)
      return 0 unless setup_coords && activity_coords
      Geo.distance_strength(setup_coords,
                            activity_coords,
                            setup.range_m)
    end
  end
end
