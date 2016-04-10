require 'rails_helper'

describe RoughCutEditor do
  set(:user) { create(:user) }
  set(:ride) do
    r = create(:ride, user: user)
    r.create_time_series_data timestamps: Array.new(11) { |i| t(i) },
                              latitudes: [0, 0, 0, 1, 2, 3, 2, 1, 0, 0, 0],
                              longitudes: [0, 1, 2, 2, 2, 2, 2, 2, 2, 1, 0]
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
      expect(EditProcessorJob).to receive(:perform_later).twice.with(edit: kind_of(Edit))
      subject.call
      expect(ride.edits.length).to eq(2)
    end
  end
end
