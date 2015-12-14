desc 'Try generating a test video'
namespace :replay do
  task :test => :environment do
    @now = DateTime.now
    def t(s)
      @now.since(s)
    end

    u = User.first_or_create(email: 'fake@afl3j293fl2.com', password: 'password', password_confirmation: 'password')
    fail "#{u.errors.full_messages}" unless u.persisted?
    r = Ride.create(user: u)
    fail "#{r.errors.full_messages}" unless r.persisted?
    [
      [0,0,t(0)],
      [0,10,t(2)],
      [0,20,t(4)],
      [0,30,t(6)],
      [0,40,t(8)]
    ].each do |arr|
     l = Location.create(trackable: r, timestamp: arr[2], latitude: arr[0], longitude: arr[1])
     fail 'no persist' unless l.persisted?
    end

    v1 = 'movie1.mp4'
    v2 = 'movie2.mp4'
    v3 = 'movie3.mp4'

    c1 = Camera.create(range_m: 110*1000) 
    Location.create(trackable: c1, latitude: 0, longitude: 0)
    fail 'no video1' unless Video.create(source: Rails.root.join(v1),
                 camera: c1,
                 start_at: t(0),
                 end_at: t(7))

    c2 = Camera.create(range_m: 110*1000)
    Location.create(trackable: c2, latitude: 0, longitude: 20)
    fail 'no video2' unless Video.create(source: Rails.root.join(v2),
                 camera: c2,
                 start_at: t(0),
                 end_at: t(8))

    c3 = Camera.create(range_m: 110*1000)
    Location.create(trackable: c3, latitude: 0, longitude: 38)
    fail 'no video3' unless Video.create(source: Rails.root.join(v3),
                 camera: c3,
                 start_at: t(0),
                 end_at: t(11))

    edit = Edit.create(user: u)

    8.times do |i|
      edit.build_cuts(t(i), t(i + 1))
    end
    edit.save!

    # binding.pry

    fail 'No videos' if edit.videos.empty? 
    fail 'No cuts were made' if edit.cuts.empty?

    cutter = Cutter.new(edit: edit)
    cutter.call
  end
end