# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# puts 'Reminder: A worker should be running.'

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
multiplier = spread * km_per_m * latlng_per_km
activity = brendan.activities.where(strava_name: 'SeedRide').first_or_create! do |activity|
  activity.strava_name = 'SeedRide'
  activity.strava_start_at = now
  activity.timestamps = Array.new(activity_length) { |i| i }
  activity.latitudes = Array.new(activity_length) { |i| lat + i * multiplier }
  activity.longitudes = Array.new(activity_length) { |i| long + i * multiplier }
end

setup_index = (activity_length/2).to_i

segment = Segment.where(name: 'SeedSegment').first_or_create!(
  strava_segment_id: 'strava_seed_segment'
)
segment_effort = activity.segment_efforts.where(segment: segment).first_or_create!(
  strava_segment_effort_id: 'strava_seed_segment_effort',
  name: 'Seed segment effort',
  start_at: now.since(setup_index.seconds),
  end_at: now.since(setup_index.seconds + 1.seconds),
  elapsed_time: 1,
  moving_time: 1,
  start_index: setup_index,
  end_index: setup_index + 1
)

setup = brendan.setups.where(name: 'laptop').first_or_create! do |setup|
  setup.name = 'laptop'
  setup.range_m = 16.0
  setup.latitude = lat + setup_index * multiplier
  setup.longitude = long + setup_index * multiplier
end

direct_upload_key_path = S3.direct_upload_key_path('full-clipped.mp4')
full_clipped_fixture_filepath = Rails.root.join('spec','fixtures','full-clipped.mp4')
S3.upload(full_clipped_fixture_filepath, direct_upload_key_path)
S3.make_public(key: direct_upload_key_path)
upload = brendan.video_uploads.joins(:video).where(videos: { filename: 'full-clipped.mp4' }).first_or_create! do |upload|
  upload.user = brendan
  upload.setups << setup
  video = upload.create_video!(file: direct_upload_key_path,
                               filename: 'full-clipped.mp4',
                               user: brendan,
                               start_at: now.since(setup_index.seconds),
                               end_at: now.since(setup_index.seconds + 2.seconds))
  video.create_thumbnail!(image: File.open(Rails.root.join('spec','fixtures','downhill.png')),
                          user: brendan)
end

if brendan.drafts.empty?
  VideoDrafter.call(start_at: now, end_at: now.since(activity_length))
  PhotoDrafter.call(start_at: now, end_at: now.since(activity_length))
end

puts "Seeds: VideoDraft count: #{VideoDraft.all.count}"
