class Frame
  include Virtus.model

  attribute :start_at, DateTime, default: Time.at(0).to_datetime
  attribute :end_at, DateTime, default: Time.gm(Time.now.year + 100).to_datetime
  attribute :period, ActiveSupport::Duration, default: 1.second
  attribute :cut_start_at
  attribute :cut_end_at

  def self.new_from_ride(ride)
    Frame.new(start_at: ride.start_at, end_at: ride.end_at)
  end

  def cut_start_at
    @cut_start_at ||= start_at
  end

  def cut_end_at
    @cut_end_at ||= cut_start_at + period
  end

  def next!
    if cut_end_at < end_at
      self.cut_start_at = cut_end_at
      self.cut_end_at += period
      true
    else
      false
    end
  end
end
