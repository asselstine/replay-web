# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


brendan = User.where(email: 'brendan@codeandconduct.is').first_or_create! do |user|
  user.email = 'brendan@codeandconduct.is'
  user.password = 'password'
  user.password_confirmation = 'password'
end

now = DateTime.now.utc.to_time.change(usec: 0)
lat = BigDecimal.new('49.265586') # (rand - 0.5) * 180
long = BigDecimal.new('-123.155719') # (rand - 0.5) * 360
latlng_per_km =  BigDecimal.new('1.0')/BigDecimal.new('111.0')
km_per_m = BigDecimal.new('1.0') / BigDecimal.new('1000.0')

activity_length = 6
spread = 8
multiplyer = spread * km_per_m * latlng_per_km
activity = brendan.activities.where(strava_name: 'SeedRide').first_or_create! do |activity|
  activity.strava_name = 'SeedRide'
  activity.timestamps = Array.new(activity_length) { |i| now.since(i.seconds) }
  activity.latitudes = Array.new(activity_length) { |i| lat + i * multiplyer }
  activity.longitudes = Array.new(activity_length) { |i| long + i * multiplyer }
end

setup_index = (activity_length/2).to_i
laptop = brendan.cameras.where(name: 'laptop').first_or_create! do |camera|
  camera.name = 'laptop'
end

setup = brendan.setups.where(camera: laptop).first_or_create! do |setup|
  setup.range_m = 16.0
  setup.timestamp = now
  setup.latitude = lat + setup_index * multiplyer
  setup.longitude = long + setup_index * multiplyer
end

upload = brendan.uploads.joins(:video).where(videos: { filename: 'full-clipped.mp4' }).first_or_create! do |upload|
  upload.camera = laptop
  upload.build_video(file: File.open(Rails.root.join('spec',
                                                     'fixtures',
                                                     'full-clipped.mp4')),
                     start_at: now.since(setup_index.seconds),
                     end_at: now.since(setup_index.seconds + 2.seconds))
end

if brendan.drafts.empty?
  BatchProcessor.call(user: brendan)
end
