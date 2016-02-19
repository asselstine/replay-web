Resque.redis = ENV['REDISTOGO_URL']
Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
