module Edit
  class Selector
    include Virtus.model

    attribute :comparators

    def select(frame)
      comparators.each { |svc| svc.compute_strength(frame) }
      comparators.select do |comparator|
        comparator.strength > 0
      end.sort.last
    end
  end
end
