require 'rails_helper'

describe Frame do
  let(:start_at) { t(0) }
  let(:end_at) { t(4) }
  subject { Frame.new(start_at: start_at, end_at: end_at) }
  describe '#start_at' do
    it { expect(subject.start_at).to eq(t(0)) }
  end
  describe '#end_at' do
    it { expect(subject.end_at).to eq(t(1)) }
  end
  describe '#next!' do
    it 'should loops over the frames' do
      frames = []
      loop do
        frames << [subject.start_at, subject.end_at]
        break unless subject.next!
      end
      expect(frames).to eq([
                             [t(0), t(1)],
                             [t(1), t(2)],
                             [t(2), t(3)],
                             [t(3), t(4)]
                           ])
    end
  end
end
