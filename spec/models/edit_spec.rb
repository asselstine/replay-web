require 'rails_helper'

RSpec.describe Edit do
  let(:user) { build(:user) }

  subject { Edit.create(user: user) }

  describe '#build_cuts' do
    let(:vid1) { double(Video) }
    let(:vid2) { double(Video) }
    let(:vid3) { double(Video) }
    it 'should iterate through the time span one second at a time' do

      expect(subject).to receive(:find_best_video).and_return(vid1)
      expect(subject.cuts).to receive(:build)
        .with(start_at: t(0), end_at: t(1), video: vid1)
      expect(subject).to receive(:find_best_video).and_return(vid2)
      expect(subject.cuts).to receive(:build)
        .with(start_at: t(1), end_at: t(2), video: vid2)
      expect(subject).to receive(:find_best_video).and_return(vid3)
      expect(subject.cuts).to receive(:build)
        .with(start_at: t(2), end_at: t(3), video: vid3)

      subject.build_cuts(t(0),t(3))
    end
  end

  describe '#find_best_video' do
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
      edit = Edit.create(user: ride.user)
      edit.build_cuts(t(0), t(6))
      expect(edit.cuts.length).to eq(6)
      c = edit.cuts
      expect(c[0].video).to eq cam00.videos.first
      expect(c[1].video).to eq cam01.videos.first
      expect(c[2].video).to eq cam02.videos.first
      expect(c[3].video).to eq cam12.videos.first
      expect(c[4].video).to eq cam22.videos.first
      expect(c[5].video).to eq cam22.videos.first
    end
  end
end
