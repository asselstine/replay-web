module RelativeTime 
  @@_time = DateTime.now
  def t(seconds)
    @@_time.since(seconds)
  end
end
