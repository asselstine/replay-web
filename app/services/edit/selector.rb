# rubocop:disable Style/ClassAndModuleChildren
class Edit::Selector
  include Virtus.model

  attribute :comparators

  def find_best(frame)
    comparators.each { |svc| svc.compute_strength(frame) }
    comparators.select do |comparator|
      comparator.strength > 0
    end.sort.last
  end
end
