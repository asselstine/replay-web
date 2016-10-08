require 'rails_helper'

RSpec.describe Job do
  subject do
    Job.new(rotation: rotation)
  end

  describe '#rotate_elastic_transcoder_format' do
    context 'for auto' do
      let(:rotation) { :rotate_auto }
      it { expect(subject.rotate_elastic_transcoder_format).to eq('auto') }
    end

    context 'for rotate 90' do
      let(:rotation) { :rotate_90 }
      it { expect(subject.rotate_elastic_transcoder_format).to eq('90') }
    end
  end
end
