require 'rails_helper'

RSpec.describe Edit::VideoComparator do
  let(:setup) { double(coords: double, range_m: 7) }
  let(:activity) { double }
  let(:strength) { nil }

  subject do
    Edit::VideoComparator.new(setup: setup,
                              activity: activity,
                              strength: strength)
  end

  describe '#<=>' do
    let(:strength) { 0.5 }
    it { expect(subject < new_strength(0)).to be_falsey }
    it { expect(subject < new_strength(1)).to be_truthy }
    it do
      expect(subject.between?(new_strength(0), new_strength(1)))
        .to be_truthy
    end
  end

  describe '#compute_strength' do
    let(:videos) { [double] }
    before(:each) do
      expect(setup).to receive(:videos_during)
        .with(kind_of(Edit::Frame)).and_return(videos)
    end
    context 'with an video during' do
      before(:each) do
        expect(activity).to receive(:coords_at)
          .with(t(0)).and_return(:coords)
        expect(Geo).to receive(:distance_strength)
          .with(setup.coords, :coords, setup.range_m).and_return(0.8)
        subject.compute_strength(Edit::Frame.new(start_at: t(0)))
      end
      it 'should set the video' do
        expect(subject.video).to be(videos.first)
      end
      it 'should set the strength as the distance' do
        expect(subject.strength).to eq(0.8)
      end
    end
    context 'with no videos' do
      let(:videos) { [] }
      before(:each) do
        subject.compute_strength(Edit::Frame.new(start_at: t(0)))
      end
      it 'should set the video as nil' do
        expect(subject.video).to be_nil
      end
      it 'should have a strength of zero' do
        expect(subject.strength).to eq(0)
      end
    end
  end

  def new_strength(strength)
    Edit::VideoComparator.new(strength: strength)
  end
end
