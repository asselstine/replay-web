require 'rails_helper'

describe LocationSample do

  describe '#closest_to' do

    before(:each) do
      @ls1 = create(:location_sample, :timestamp => 1.day.ago)
      @ls2 = create(:location_sample, :timestamp => 2.days.ago)
      @ls3 = create(:location_sample, :timestamp => 5.days.ago)
    end

    it 'should return the closest sample that occurred after' do
      expect(LocationSample.closest_to( 3.days.ago )).to eq(@ls2)
    end

    it 'should return the closest sample that occurred before' do
      expect(LocationSample.closest_to( 4.days.ago )).to eq(@ls3)
    end
  end

  let(:ride) {
    create(:ride)
  }

  def create_loc(time, lat, lng)
    create(:location_sample, :ride => ride.reload, :timestamp => time, :latitude => lat, :longitude => lng)
  end

  describe '#interpolate' do

    it 'should cleanly interpolate after 3 values' do
      @ls1 = create_loc(3.seconds.ago, 1, 1)
      expect(ride.reload.location_samples.not_interpolated.length).to eq(1)
      @ls2 = create_loc(2.seconds.ago, 2, 2)
      expect(ride.reload.location_samples.length).to eq(2)
      @ls3 = create_loc(1.seconds.ago, 3, 3)
      expect(ride.reload.location_samples.length).to eq(3 + ((2 / LocationSample::INTERP_STEP) - 1) )
    end

  end

end