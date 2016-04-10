require 'rails_helper'

RSpec.describe GenerateRideEdit do
  let(:timestamps) { [t(0), t(4)] }
  let(:latitudes) { [lat_rand, lat_rand] }
  let(:longitudes) { [long_rand, long_rand] }
  let(:ride) do
    r = create(:ride, edits: [])
    r.create_time_series_data timestamps: timestamps,
                              latitudes: latitudes,
                              longitudes: longitudes
    r
  end
  let(:user) { create(:user, rides: [ride].compact) }

  subject { GenerateRideEdit.new(user: user, ride: ride) }

  context 'when the user has a ride with no edit' do
    let(:edit) { double(Edit, cuts: cuts, persisted?: true) }

    context 'and the new edit contains a cut' do
      let(:cuts) { [1] }

      it 'should build an edit for the ride' do
        expect(ride.edits).to receive(:build).with(user: user).and_return(edit)
        expect(edit).to receive(:build_cuts).with(timestamps.first, timestamps.last)
        expect(edit).to receive(:save!)
        subject.call
      end
    end

    context 'when the edit is empty' do
      let(:cuts) { [] }
      let(:edit) { double(cuts: cuts, persisted?: false) }

      it 'should destroy the edit' do
        expect(ride.edits).to receive(:build).with(user: user).and_return(edit)
        expect(edit).to receive(:build_cuts).with(timestamps.first, timestamps.last)
        expect(ride.edits).to receive(:destroy).with(edit)
        subject.call
      end
    end
  end
end
