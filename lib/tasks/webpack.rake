desc 'Calls webpack to compile the JavaScript'
task :webpack do
  puts 'Running webpack...'
  output = `NODE_ENV=production $(npm bin)/webpack -g`
  puts output
  puts 'Done webpack.'
end

# Adds an additional prereq to the assets:precompile step so that it compiles
# the webpack JavaScript.
Rake::Task['assets:precompile'].enhance ['webpack']
