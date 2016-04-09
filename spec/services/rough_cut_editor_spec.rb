require 'rails_helper'

describe RoughCutEditor do
  set(:user) { create(:user) }
  set(:ride) do
    r = create(:ride, user: user)
    locations = [
      [0, 0],
      [0, 1],
      [0, 2],
      [1, 2],
      [2, 2],
      [3, 2],
      [2, 2],
      [1, 2],
      [0, 2],
      [0, 1],
      [0, 0]
    ]
    time = 0
    locations.each do |lat, lng|
      create(:location,
             trackable: r, latitude: lat, longitude: lng, timestamp: t(time))
      time += 1
    end
    r
  end

  subject { RoughCutEditor.new(ride: ride) }

  context 'when the user returns to the same camera later' do
    let!(:cameras) do
      locations = [
        [0, 0]
      ]
      locations.map do |lat, lng|
        create(:camera, # [0, 1] to []
               :static, start_at: t(0), range_m: 112_000, lat: lat, lng: lng)
      end
    end

    it 'should create two edits' do
      subject.call
      expect(ride.edits.length).to eq(2)
    end
  end
end
