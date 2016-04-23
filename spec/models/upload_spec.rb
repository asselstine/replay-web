require 'rails_helper'

RSpec.describe Upload do
  let(:now) { DateTime.now }
  def time(seconds)
    now.since(seconds)
  end

  subject { create(:upload) }

  context 'class' do
    subject { Upload }

    describe '#during' do
      let(:start_at) { time(0) }
      let(:end_at) { time(5) }
      let(:upload) { create(:upload, start_at: start_at, end_at: end_at) }

      def during(start_at, end_at)
        expect(subject.during(start_at, end_at))
      end

      context 'upload is within the tick' do
        it { during(time(-1), time(0)).to_not include(upload) }
        it { during(time(-1), time(1)).to include(upload) }
        it { during(time(0), time(1)).to include(upload) }
        it { during(time(2), time(3)).to include(upload) }
        it { during(time(5), time(6)).to_not include(upload) }
      end
    end
  end
end
