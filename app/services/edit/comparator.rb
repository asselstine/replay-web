# rubocop:disable Style/ClassAndModuleChildren
class Edit::Comparator
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
    Geo.distance_strength(setup.coords,
                          activity.coords_at(frame.start_at),
                          setup.range_m)
  end
end
