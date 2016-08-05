require 'simplecov'
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
end
SimpleCov.start do
  add_filter '/spec'
  add_filter '/features'
  add_filter '/bin'
  add_filter '/lib/tasks'
  add_filter '/vendor'
end
