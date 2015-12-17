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
      expect(subject).to receive(:next_cut).with(nil, t(0), t(1), vid1).and_return(3)
      expect(subject).to receive(:find_best_video).and_return(vid2)
      expect(subject).to receive(:next_cut).with(3, t(1), t(2), vid2).and_return(7)
      expect(subject).to receive(:find_best_video).and_return(vid3)
      expect(subject).to receive(:next_cut).with(7, t(2), t(3), vid3)

      subject.build_cuts(t(0),t(3))
    end
  end

  describe '#next_cut' do
    let(:video) { create(:video) }
    context 'without a previous cut' do
      it 'should create a new one' do
        expect(subject.cuts).to receive(:build).with(start_at: t(0), 
                                                     end_at: t(1), 
                                                     video: video)
        subject.send(:next_cut, nil, t(0), t(1), video)
      end
    end
    context 'with a previous cut' do
      context 'with the same video' do
        context 'with a different time' do
          let(:previous_cut) { build(:cut, edit: subject, video: video) }
          it 'should build a new cut' do
            expect(subject.cuts).to receive(:build).with(start_at: t(0),
                                                         end_at: t(1),
                                                         video: video)
            subject.send(:next_cut, previous_cut, t(0), t(1), video)
          end
        end
        context 'with end_at matching the start_at' do
          let(:previous_cut) { build(:cut, start_at: t(-1), end_at: t(0), edit: subject, video: video) }
          it 'should extend the previous cut' do
            expect(previous_cut).to receive(:end_at=).with(t(1))
            subject.send(:next_cut, previous_cut, t(0), t(1), video)
          end
        end
      end
      context 'with a different video' do
        let(:previous_cut) { build(:cut, edit: subject, start_at: t(-1), end_at: t(0), video: create(:video)) }
        it 'should build a new cut' do
          expect(subject.cuts).to receive(:build).with(start_at: t(0),
                                                       end_at: t(1),
                                                       video: video)
          subject.send(:next_cut, previous_cut, t(0), t(1), video) 
        end
      end
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
      ride.user.locations.each do |loc|
        puts "U location: #{loc.timestamp.to_f}, #{loc.latitude}, #{loc.longitude}"
      end
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
