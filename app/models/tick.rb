class Tick 
  include Virtus.model

  attribute :start_time, Integer
  attribute :duration, Integer

  def self.zeroS
    Tick.new(start_time: 0, duration: 1000)
  end
end
