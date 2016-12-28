require 'rails_helper'

RSpec.describe Outputs::BuildHls do
  subject { Outputs::BuildHls.new(job: job) }
  let(:job) { double(Job, video: video, outputs: outputs) }
  let(:outputs) { double(Output::ActiveRecord_Relation) }
  let(:video) do
    double(Video, vertical_resolution: vertical_resolution,
                  source_filename_no_ext: 'source_no_ext')
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 480 }

    it 'should only create the low def preset' do
      expect(outputs).to receive(:build)
        .with(key: Outputs::BuildHls::OUTPUT_480_KEY,
              segment_duration: 10,
              preset_id: Outputs::BuildHls::OUTPUT_480_PRESET_ID,
              media_type: :video)
      expect(outputs).to receive(:build)
        .with(key: Outputs::BuildHls::OUTPUT_160K_AUDIO_KEY,
              segment_duration: 10,
              preset_id: Outputs::BuildHls::OUTPUT_160K_AUDIO_PRESET_ID,
              media_type: :audio)
      subject.call
    end
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 720 }

    it 'should only create the low def preset' do
      expect(outputs).to receive(:build)
        .with(key: Outputs::BuildHls::OUTPUT_720_KEY,
              segment_duration: 10,
              preset_id: Outputs::BuildHls::OUTPUT_720_PRESET_ID,
              media_type: :video)
      expect(outputs).to receive(:build)
        .with(key: Outputs::BuildHls::OUTPUT_480_KEY,
              segment_duration: 10,
              preset_id: Outputs::BuildHls::OUTPUT_480_PRESET_ID,
              media_type: :video)
      expect(outputs).to receive(:build)
        .with(key: Outputs::BuildHls::OUTPUT_160K_AUDIO_KEY,
              segment_duration: 10,
              preset_id: Outputs::BuildHls::OUTPUT_160K_AUDIO_PRESET_ID,
              media_type: :audio)
      subject.call
    end
  end
end
