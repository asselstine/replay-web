module RelativeTime 
  @@_time = Time.now.change(usec: 0).to_datetime 
  def t(seconds)
    @@_time.since(seconds)
  end
end
