require 'rails_helper'

describe Ride do

  let(:ride) {
    create(:ride)
  }

  def create_loc(time, lat, lng)
    create(:location_sample, :ride => ride.reload, :timestamp => time, :latitude => lat, :longitude => lng)
  end

  describe '#interpolate' do

    it 'should cleanly interpolate after 3 values' do

      pending 'whether this feature is necessary'

      t = Time.now

      @ls1 = create_loc(t, 1, 1)
      expect(ride.reload.location_samples.not_interpolated.length).to eq(1)
      @ls2 = create_loc(t+1, 2, 2)
      expect(ride.reload.location_samples.length).to eq(2)
      @ls3 = create_loc(t+2, 3, 3)
      expect(ride.reload.location_samples.length).to eq(3 + ((2 / LocationSample::INTERP_STEP) - 1) )

      expect(ride.reload.location_samples.preceding(t+0.501).first.latitude).to eq(1.5)
      expect(ride.reload.location_samples.preceding(t+1.501).first.latitude).to eq(2.5)

    end

  end

end