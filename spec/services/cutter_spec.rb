require 'rails_helper'

RSpec.describe EditProcessor do

  subject { EditProcessor.new }

  it 'should do something' do
    subject
  end

  describe 'class' do

    subject { EditProcessor }

    let(:video) { double(Video, start_at: t(0)) }
    let(:cut) { double(Cut, start_at: t(1), end_at: t(2), video: video) }

    describe '#cut_start_time_s' do
      it do
        expect(subject.cut_start_time_s(cut)).to eq('00:00:01.000')
      end
    end
    
    describe '#cut_duration_s' do
      it do
        expect(subject.cut_duration_s(cut)).to eq('00:00:01.000')
      end
    end
  end
end
