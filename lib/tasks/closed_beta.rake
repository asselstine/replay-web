desc 'Generate the Replay Closed Beta Videos'
namespace :replay do
  task :beta1 => :environment do


    # Jer's rides: 
    #
    # Ride 95:
    # start:  2015-12-19 19:40:10
    # end:    2015-12-19 21:02:12  
    #
    # Ride 94:
    # started: Sat, 19 Dec 2015 21:13:48 UTC +00:00
    # ended: Sat, 19 Dec 2015 21:31:49 UTC +00:00
    #
    # Dan's rides:
    # 
    # 

    Video.destroy_all
    Cut.destroy_all
    Camera.destroy_all
    Edit.destroy_all

    def f(name)
      Rails.root.join('640x360',name)
    end

    @start_time = DateTime.parse('2015-12-19 20:52:30 UTC')
    # 20:59:40
    second_run_offset = (7.minutes + 10.seconds)
    # 21:28:58
    third_offset = (36.minutes + 28.seconds) 
    def t(s)
      @start_time.since(s)
    end

    users = [User.find(4)]

    phil1 = Camera.create(range_m: 10) 
    Location.create(trackable: phil1, latitude: 49.35788, longitude: -123.03879)
    p1, p2, p3 = 3.seconds, second_run_offset - 2.5.seconds, 5.minutes
    [
      {source: f('20151219-MVI_2266.mp4'), start_at: t(p1), end_at: t(p1+55)},
      {source: f('20151219-MVI_2267.mp4'), start_at: t(p2), end_at: t(p2+56)}, 
      {source: f('20151219-MVI_2268.mp4'), start_at: t(p3), end_at: t(p3+21)}
    ].each do |vid|
      phil1.videos.create(vid)
    end

    phil2 = Camera.create(range_m: 10) 
    p4, p5 = third_offset - 6.seconds, 25.minutes
    Location.create(trackable: phil2, latitude: 49.35742, longitude: -123.03809)
    [
      {source: f('20151219-MVI_2290.mp4'), start_at: t(p4), end_at: t(p4+61)}, 
      {source: f('20151219-MVI_2291.mp4'), start_at: t(p5), end_at: t(p5+21)} 
    ].each do |vid|
      phil2.videos.create(vid)
    end

    arthur1 = Camera.create(range_m: 10) 
    a1, a2 = -47.seconds, second_run_offset - 18.seconds
    Location.create(trackable: arthur1, latitude: 49.35776, longitude: -123.03898)
    [
      {source: f('Arthur\ GoPro\ -\ Run\ 1.mp4'), start_at: t(a1), end_at: t(a1+104)}, 
      {source: f('Arthur\ GoPro\ -\ Run\ 2.mp4'), start_at: t(a2), end_at: t(a2+95)} 
    ].each do |vid|
      arthur1.videos.create(vid)
    end

    arthur2 = Camera.create(range_m: 10) 
    a3 = third_offset - 10.seconds
    Location.create(trackable: arthur2, latitude: 49.35718, longitude: -123.03802)
    [
      {source: f('Arthur\ GoPro\ -\ Run\ 3.mp4'), start_at: t(a3), end_at: t(a3+61)} 
    ].each do |vid|
      arthur2.videos.create(vid)
    end

    lauren1 = Camera.create(range_m: 10)
    l1, l2 = -10.seconds, second_run_offset - 14.seconds 
    Location.create(trackable: lauren1, latitude: 49.35794, longitude: -123.03826)
    [
      {source: f('IMG_2892.mp4'), start_at: t(l1), end_at: t(l1+71)}, 
      {source: f('IMG_2893.mp4'), start_at: t(l2), end_at: t(l2+107)} 
    ].each do |vid|
      lauren1.videos.create(vid)
    end

    lauren2 = Camera.create(range_m: 10)
    l3, l4 = third_offset - 10.seconds, third_offset + 5.minutes 
    Location.create(trackable: lauren2, latitude: 49.35727, longitude: -123.0379)
    [
      {source: f('IMG_2896.mp4'), start_at: t(l3), end_at: t(l3+77.seconds)}, 
      {source: f('IMG_2897.mp4'), start_at: t(l4), end_at: t(l4+43.seconds)} 
    ].each do |vid|
      lauren2.videos.create(vid)
    end

    luc1 = Camera.create(range_m: 10)
    lt1, lt2 = 0.seconds, second_run_offset
    # 49.35814, -123.03839 OR 49.35808, -123.03828
    # halfway: 49.35812, -123.03834
    Location.create(trackable: luc1, latitude: 49.35812, longitude: -123.03834)
    [
      {source: f('Luc\ Canon6D\ -\ Run\ 1.mp4'), start_at: t(lt1), end_at: t(lt1+63.seconds)}, 
      {source: f('Luc\ Canon6D\ -\ Run\ 2.mp4'), start_at: t(lt2), end_at: t(lt2+94.seconds)} 
    ].each do |vid|
      luc1.videos.create(vid)
    end

    luc2 = Camera.create(range_m: 10)
    lt3, lt4 = third_offset - 1.second, third_offset + 5.minutes 
    Location.create(trackable: luc2, latitude: 49.35732, longitude: -123.03802)
    [
      {source: f('Luc\ Canon6D\ -\ Run\ 3.mp4'), start_at: t(lt3), end_at: t(lt3+58.seconds)}, 
      {source: f('Luc\ Canon6D\ -\ Run\ 4.mp4'), start_at: t(lt4), end_at: t(lt4+33.seconds)} 
    ].each do |vid|
      luc2.videos.create(vid)
    end

    jolene1 = Camera.create(range_m: 10)
    j1, j2 = 0.seconds, second_run_offset - 4.5.seconds
    Location.create(trackable: jolene1, latitude: 49.35813, longitude: -123.03857)
    [
      {source: f('VIDEO0048.mp4'), start_at: t(j1), end_at: t(j1+5.seconds)}, 
      {source: f('VIDEO0050.mp4'), start_at: t(j2), end_at: t(j2+96.seconds)} 
    ].each do |vid|
      jolene1.videos.create(vid)
    end

    jolene2 = Camera.create(range_m: 10)
    j3, j4 = third_offset - 13.5.second, third_offset + 5.minutes 
    Location.create(trackable: jolene2, latitude: 49.35728, longitude: -123.03789)
    [
      {source: f('VIDEO0052.mp4'), start_at: t(j3), end_at: t(j3+73.seconds)}, 
      {source: f('VIDEO0053.mp4'), start_at: t(j4), end_at: t(j4+33.seconds)} 
    ].each do |vid|
      jolene2.videos.create(vid)
    end

    users.each do |u|
      edit = Edit.create(user: u)
      edit.build_cuts(t(0), t(10.minutes))
      # edit.build_cuts(t(third_offset + 0.seconds), t(third_offset + 17.seconds))
      #edit.build_cuts(t(0), t(15))
      edit.cuts.each do |cut|
        puts "Cut #{cut.video.source} from #{cut.start_at} to #{cut.end_at}"
      end
      edit.save!
      fail 'No videos' if edit.videos.empty? 
      fail 'No cuts were made' if edit.cuts.empty?
      cutter = Cutter.new(edit: edit)
      cutter.call
      `open #{cutter.edit_filepath}`
    end
  end
end
