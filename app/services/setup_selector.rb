class SetupSelector
  include Virtus.model

  attribute :activity, Activity
  attribute :setups, Array[Setup]

  def find_best(frame)
    setup_video_comparators.each { |svc| svc.compute_strength(frame) }
    setup_video_comparators.select do |comparator|
      comparator.strength > 0
    end.sort.first
  end

  protected

  def setup_video_comparators
    @setup_video_comparators ||= setups.map do |setup|
      SetupVideoComparator.new(setup: setup, activity: activity)
    end
  end
end
