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

end