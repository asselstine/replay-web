require 'rails_helper'

RSpec.describe Edit do
  let(:user) { build(:user) }
  let(:cuts) { [] }
  let(:video_start_at) { t(0) }
  let(:video_end_at) { t(10) }
  let(:video) { double(Video, id: 0, start_at: video_start_at, end_at: video_end_at) }
  subject { Edit.new(user: user, cuts: cuts) }

  describe '#build_cuts' do
    let(:camera) { double(Camera, videos: double(Array)) }
    let(:cameras) { [camera] }
    let(:location) { double(Location, geo_array: [0,0]) }
    let(:videos) { [video] }

    def expect_cut(start_at, end_at, video)
      expect(subject).to receive(:build_cut).with(start_at, end_at, video)
    end

    before(:each) do
      expect(Camera).to receive(:with_video_during)
      expect(Camera).to receive(:sort_by_strength).and_return cameras
      expect(camera.videos).to receive(:during).and_return videos
    end

    context 'with a fraction of a video' do
      it do
        expect_cut(t(4), t(6), video)
        subject.build_cuts(t(4), t(6))
      end 
    end

    context 'where the video start halfway through' do
      let(:video_start_at) { t(8) }
      let(:video_end_at) { t(10) } 
      it do
        expect_cut(t(8), t(9), video)
        subject.build_cuts(t(6), t(9))
      end
    end

    context 'where the video ends before the end' do
      let(:video_start_at) { t(6) }
      let(:video_end_at) { t(8) }
      it do
        expect_cut(t(6), t(8), video)
        subject.build_cuts(t(6), t(10))
      end
    end

    context 'where it overlaps two videos' do
      let(:video1) { double(Video, id: 1, start_at: t(0), end_at: t(5)) }
      let(:video2) { double(Video, id: 2, start_at: t(5), end_at: t(6)) }
      let(:videos) { [video1, video2] }
      it do
        expect_cut(t(2), t(5), video1)
        expect_cut(t(5), t(6), video2)
        subject.build_cuts(t(2), t(7))
      end
    end
  end

  describe '#build_cut' do
    let(:existing) { nil }
    context 'with existing' do
      let(:existing) { build(:cut, video_id: video.id) } 
      it do
        expect(subject).to receive(:previous_cut).and_return(existing)
        expect(subject.send(:build_cut, t(0), t(1), video)).to be existing
      end
    end
    context 'new' do
      it do
        expect(subject).to receive(:previous_cut).and_return(existing)
        expect(subject.cuts).to receive(:build).with(start_at: t(0), end_at: t(1), video: video)
        subject.send(:build_cut, t(0), t(1), video)
      end
    end
  end

  describe 'class' do
    subject { Edit }
  end


  describe 'Integration!' do
    
    let!(:ride) do
      time = 0
      r = create(:ride)
      2.times do |i|
        create(:location, trackable: r, latitude: 0, longitude: i, timestamp: t(time))
        time += 1
      end 
      4.times do |i|
        create(:location, trackable: r, latitude: i, longitude: 2, timestamp: t(time))
        time += 1
      end 
      r 
    end

    let!(:cam00) { create(:camera, :with_static, video_at: t(0), range_m: 100000, lat: 0, lng: 0) }
    let!(:cam01) { create(:camera, :with_static, video_at: t(0), range_m: 100000, lat: 0, lng: 1) }
    let!(:cam02) { create(:camera, :with_static, video_at: t(0), range_m: 100000, lat: 0, lng: 2) }
    let!(:cam12) { create(:camera, :with_static, video_at: t(0), range_m: 100000, lat: 1, lng: 2) }
    let!(:cam22) { create(:camera, :with_static, video_at: t(0), range_m: 100000, lat: 2, lng: 2) }

    let(:user) { ride.user }

    it 'should create the right cuts' do
      pending 'more work'

      edit = Edit.new(user: ride.user)

      6.times do |i|
        edit.build_cuts(t(i), t(i + 1))
      end

      pp edit
      pp edit.cuts

      expect(edit.cuts.length).to eq(5)

      c = edit.cuts

      expect(c[0].video).to eq cam00.videos.first
      expect(c[1].video).to eq cam01.videos.first
      expect(c[2].video).to eq cam02.videos.first
      expect(c[3].video).to eq cam12.videos.first
      expect(c[4].video).to eq cam22.videos.first
      expect(c[4].start_at).to eq t(4)
      expect(c[4].end_at).to eq t(6)
    end

  end
end
