require 'rails_helper'

RSpec.describe MultiVideoEditor do
  set(:user) { create(:user) }
  set(:ride) do
    r = create(:ride, user: user)
    r.create_time_series_data timestamps: Array.new(7) { |i| t(i) },
                              latitudes: [0, 0, 0, 1, 2, 3, 3],
                              longitudes: [0, 1, 2, 2, 2, 2, 2]
    r
  end

  subject { MultiVideoEditor.new(edit: Edit.new(user: user, ride: ride)) }

  describe '#call' do
    let!(:cameras) do
      locations = [
        [0, 0],
        [0, 1],
        [0, 2],
        [1, 2],
        [2, 2]
      ]
      locations.map do |lat, lng|
        create(:camera,
               :static, start_at: t(0), range_m: 200_000, lat: lat, lng: lng)
      end
    end

    it 'should create the right cuts' do
      edit = subject.call
      expect(edit.cuts.length).to eq(6)
      c = edit.cuts
      expect(c[0].video).to eq cameras[0].videos.first
      expect(c[1].video).to eq cameras[1].videos.first
      expect(c[2].video).to eq cameras[2].videos.first
      expect(c[3].video).to eq cameras[3].videos.first
      expect(c[4].video).to eq cameras[4].videos.first
      expect(c[5].video).to eq cameras[4].videos.first
    end
  end
end
