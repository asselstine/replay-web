require 'rails_helper'

describe LocationSample do

  let(:ride) {
    create(:ride)
  }

  before(:each) do
    @now = Time.now
    @ls1 = create(:location_sample, :timestamp => @now+1)
    @ls2 = create(:location_sample, :timestamp => @now+2)
    @ls3 = create(:location_sample, :timestamp => @now+5)
  end

  describe '#closest_to' do

    it 'should return the closest sample that occurred after' do
      expect(LocationSample.closest_to( @now+3.4 )).to eq(@ls2)
    end

    it 'should return the closest sample that occurred after' do
      expect(LocationSample.closest_to( @now+3.6 )).to eq(@ls3)
    end

    it 'should return the closest sample that occurred before' do
      expect(LocationSample.closest_to( @now+4 )).to eq(@ls3)
    end

  end

  describe '#preceding' do

    it 'should return the previous 1' do
      expect(LocationSample.preceding(@ls3.timestamp).to_a).to eq([@ls2])
    end

    it 'should return the previous +N' do
      expect(LocationSample.preceding(@ls3.timestamp, 2).to_a).to eq([@ls2, @ls1])
    end

  end

  describe '#following' do

    it 'should return the next 1' do
      expect(LocationSample.following(@ls1.timestamp).to_a).to eq([@ls2])
    end

    it 'should return the next 2' do
      expect(LocationSample.following(@ls1.timestamp, 2).to_a).to eq([@ls2, @ls3])
    end
  end

  describe '#between' do

    it 'should return the samples between timestamps' do
      expect( LocationSample.between(@ls1.timestamp, @ls3.timestamp).to_a ).to eq([@ls2])
    end

  end

end