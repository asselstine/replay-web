require 'rails_helper'

RSpec.describe Draft do
  let(:activity) do
    create(:activity,
           timestamps: [t(0), t(1), t(2), t(3)],
           latitudes: [0, 1, 2, 3],
           longitudes: [2, 3, 5, 7])
  end
  let(:start_at) { t(1) }
  let(:end_at) { t(3) }
  subject { Draft.new(activity: activity, start_at: start_at, end_at: end_at) }

  describe '#latitudes' do
    it 'should return the subset of latitudes for this draft' do
      expect(subject.latitudes).to eq([1.to_d, 2.to_d, 3.to_d])
    end
  end

  describe '#longitudes' do
    it 'should return the subset of latitudes for this draft' do
      expect(subject.longitudes).to eq([3.to_d, 5.to_d, 7.to_d])
    end

    context 'when the start_at and end_at are the same' do
      let(:end_at) { t(1) }

      it 'should return just one' do
        expect(subject.longitudes).to eq([3.to_d])
      end
    end
  end
end
