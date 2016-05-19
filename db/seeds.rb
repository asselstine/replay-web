# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Reminder: A worker should be running.'

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
setup = brendan.setups.where(name: 'laptop').first_or_create! do |setup|
  setup.name = 'laptop'
  setup.range_m = 16.0
  setup.latitude = lat + setup_index * multiplyer
  setup.longitude = long + setup_index * multiplyer
end

upload = brendan.video_uploads.joins(:video).where(videos: { filename: 'full-clipped.mp4' }).first_or_create! do |upload|
  upload.user = brendan
  upload.setups << setup
  video = upload.create_video!(file: File.open(Rails.root.join('spec',
                                                     'fixtures',
                                                     'full-clipped.mp4')),
                       user: brendan,
                       start_at: now.since(setup_index.seconds),
                       end_at: now.since(setup_index.seconds + 2.seconds))
  FFMPEG::Thumbnail.call(video: video)
end

if brendan.drafts.empty?
  BatchProcessor.call(user: brendan)
end
