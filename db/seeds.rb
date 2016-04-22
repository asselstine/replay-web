# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


brendan = User.where(email: 'brendan@codeandconduct.is').first_or_create do |user|
  user.email = 'brendan@codeandconduct.is'
end

now = DateTime.now.utc.to_time.change(usec: 0)
lat = BigDecimal.new('49.265586') # (rand - 0.5) * 180
long = BigDecimal.new('-123.155719') # (rand - 0.5) * 360
latlng_per_km =  BigDecimal.new('1.0')/BigDecimal.new('111.0')
km_per_m = BigDecimal.new('1.0') / BigDecimal.new('1000.0')

ride_length = 6
spread = 8
multiplyer = spread * km_per_m * latlng_per_km
ride = brendan.rides.where(strava_name: 'SeedRide').first_or_create do |ride|
  ride.strava_name = 'SeedRide'
  ride.create_time_series_data(timestamps: Array.new(ride_length) do |i|
                                 now.since(i.seconds)
                               end,
                               latitudes: Array.new(ride_length) do |i|
                                 lat + i * multiplyer
                               end,
                               longitudes: Array.new(ride_length) do |i|
                                 long + i * multiplyer
                               end)
end

camera_index = (ride_length/2).to_i
laptop = brendan.cameras.where(name: 'laptop').first_or_create do |camera|
  camera.name = 'laptop'
  camera.range_m = 16.0
  camera.timestamp = now
  camera.latitude = lat + camera_index * multiplyer
  camera.longitude = long + camera_index * multiplyer
end

video = laptop.videos.where(filename: 'full-clipped.mp4').first_or_create do |video|
  video.start_at = now.since(camera_index.seconds)
  video.end_at = now.since(camera_index.seconds + 2.seconds)
  video.file = File.open(Rails.root.join('spec',
                                         'fixtures',
                                         'full-clipped.mp4'))
end

if ride.edits.empty?
  RoughCutEditor.call(ride: ride, process: false)
  ride.edits.each do |edit|
    EditProcessorJob.perform_now(edit: edit)
  end
end
