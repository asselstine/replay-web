require 'rails_helper'

describe Edit::Selector do
  let(:comparators) { [] }
  let(:frame) { double }
  subject { Edit::Selector.new(comparators: comparators) }

  context 'with no setup' do
    it 'should return nil' do
      expect(subject.select(frame)).to be_nil
    end
  end

  context 'with one setup' do
    let(:comparator1) { Edit::Comparators::VideoComparator.new(strength: 1) }
    let(:comparators) { [comparator1] }

    it 'should return the setup' do
      expect(comparator1).to receive(:compute_strength)
        .with(frame)
      expect(subject.select(frame)).to eq(comparator1)
    end

    context 'with a strength of zero' do
      let(:comparator1) { Edit::Comparators::VideoComparator.new(strength: 0) }
      it 'should return nil' do
        expect(comparator1).to receive(:compute_strength)
          .with(frame)
        expect(subject.select(frame)).to be_nil
      end
    end
  end

  context 'with two setups' do
    let(:comparator1) { Edit::Comparators::VideoComparator.new(strength: 0.4) }
    let(:comparator2) { Edit::Comparators::VideoComparator.new(strength: 0.8) }
    let(:comparators) { [comparator1, comparator2] }

    it 'should return the strongest setup' do
      expect(comparator1).to receive(:compute_strength)
        .with(frame)
      expect(comparator2).to receive(:compute_strength)
        .with(frame)
      expect(subject.select(frame)).to eq(comparator2)
    end
  end
end
