require 'rails_helper'

RSpec.describe Video do

  let(:now) { DateTime.now }
  def time(seconds)
    now.since(seconds)
  end

  subject { create(:video) }


  context 'class' do
    subject { Video }

    describe '#during' do
      let(:start_at) { time(0) }
      let(:end_at) { time(5) }
      let(:video) { create(:video, start_at: start_at, end_at: end_at) }

      def during(start_at, end_at)
        expect(subject.during(start_at, end_at))
      end

      context 'video is within the tick' do
        it { during(time(-1),time(0)).to_not include(video) }
        it { during(time(-1),time(1)).to include(video) }
        it { during(time(0), time(1)).to include(video) }
        it { during(time(2), time(3)).to include(video) }
        it { during(time(5), time(6)).to_not include(video) }
      end 
    end

    describe '#inbetween?' do
      it { expect(subject.inbetween?(1,2,3,4)).to be_falsey }
      it { expect(subject.inbetween?(1,3,3,4)).to be_falsey }
      it { expect(subject.inbetween?(1,4,3,4)).to be_truthy }
      it { expect(subject.inbetween?(1,5,3,4)).to be_truthy }
      it { expect(subject.inbetween?(3,3.01,3,4)).to be_truthy }
      it { expect(subject.inbetween?(4,5,3,4)).to be_falsey }
      it { expect(subject.inbetween?(4,5,3,4)).to be_falsey }
      it { expect(subject.inbetween?(3.99,5,3,4)).to be_truthy }
    end
  end
end