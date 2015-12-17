require 'rails_helper'

RSpec.describe Edit do
  let(:user) { build(:user) }

  subject { Edit.create(user: user) }

  describe '#build_cuts' do
    it 'should iterate through the time span one second at a time' do
      expect(subject).to receive(:build_cut).with(t(0),t(1))
      expect(subject).to receive(:build_cut).with(t(1),t(2))
      expect(subject).to receive(:build_cut).with(t(2),t(3))
      subject.build_cuts(t(0),t(3))
    end
  end

  describe '#build_cut' do
    context 'with no video' do
      it 'should do nothing' do
        expect(subject).to receive(:find_best_video).and_return(nil)
        subject.send(:build_cut, t(0),t(1))
        expect(subject.cuts).to be_empty
      end
    end
    context 'with a new cut' do
      let(:video) { build(:video) }
      it 'should create a new one' do
        expect(subject).to receive(:find_best_video).and_return(video)
        expect(subject.cuts).to receive(:create).with(start_at: t(0), 
                                                     end_at: t(1), 
                                                     video: video)
        subject.send(:build_cut, t(0), t(1))
      end
    end
    context 'with another cut with the same video at the same time' do
      let(:video) { build(:video) }
      let!(:cut) { create(:cut, video: video, start_at: t(0), end_at: t(1)) }
      subject { create(:edit, cuts: [cut]) }
      it 'should reuse the old one' do
        expect(subject.cuts).to include(cut)
        expect(subject).to receive(:find_best_video).and_return(video)
        subject.send(:build_cut, t(1), t(2))
        expect(subject.reload.cuts.length).to eq(1)
        expect(subject.cuts.first).to eq(cut)
        expect(subject.cuts.first.end_at).to eq(t(2))
      end
    end
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
