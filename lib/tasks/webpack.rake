namespace :webpack do
  desc 'Calls webpack to compile the JavaScript'
  task :run do
    puts 'Running webpack...'
    output = `NODE_ENV=production webpack`
    puts output
    puts 'Done webpack.'
  end
end

# Adds an additional prereq to the assets:precompile step so that it compiles
# the webpack JavaScript.
Rake::Task['assets:precompile'].enhance ['webpack:run']
