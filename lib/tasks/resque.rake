require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    ENV['QUEUES'] ||= '*'
    ENV['TERM_CHILD'] ||= '1'
    ENV['RESQUE_TERM_TIMEOUT'] ||= '10'
  end
end
