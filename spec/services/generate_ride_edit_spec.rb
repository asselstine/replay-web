require 'rails_helper'

RSpec.describe GenerateRideEdit do
  let(:start_at) { t(0) }
  let(:end_at) { t(4) }
  let(:user_location) { create(:location, timestamp: start_at) }
  let(:user_location2) { create(:location, timestamp: end_at) }
  let(:ride) do
    create(:ride, edits: [], locations: [user_location, user_location2])
  end
  let(:user) { create(:user, rides: [ride].compact) }

  subject { GenerateRideEdit.new(user: user, ride: ride) }

  context 'when the user has a ride with no edit' do
    let(:edit) { double(Edit, cuts: cuts, persisted?: true) }

    context 'and the new edit contains a cut' do
      let(:cuts) { [1] }

      it 'should build an edit for the ride' do
        expect(ride.edits).to receive(:build).with(user: user).and_return(edit)
        expect(edit).to receive(:build_cuts).with(start_at, end_at)
        expect(edit).to receive(:save!)
        subject.call
      end
    end

    context 'when the edit is empty' do
      let(:cuts) { [] }
      let(:edit) { double(cuts: cuts, persisted?: false) }

      it 'should destroy the edit' do
        expect(ride.edits).to receive(:build).with(user: user).and_return(edit)
        expect(edit).to receive(:build_cuts).with(start_at, end_at)
        expect(ride.edits).to receive(:destroy).with(edit)
        subject.call
      end
    end
  end
end
