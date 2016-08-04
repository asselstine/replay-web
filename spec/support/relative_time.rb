module RelativeTime
  @@time = Time.zone.now.change(usec: 0).to_datetime
  def t(seconds)
    @@time.since(seconds)
  end
end
