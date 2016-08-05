module RelativeTime
  def t(seconds)
    @time ||= Time.zone.now.change(usec: 0).to_datetime
    @time.since(seconds)
  end
end
