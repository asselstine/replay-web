require 'rails_helper'

RSpec.describe Jobs::BuildOutputs do
  subject { Jobs::BuildOutputs.new(video: video, rotation: rotation) }
  let(:video) do
    double(Video, vertical_resolution: vertical_resolution,
                  source_filename_no_ext: 'source_no_ext')
  end
  let(:rotation) { 'auto' }

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 480 }

    it 'should only create the low def preset' do
      expect(subject.call).to eq(
        [
          {
            key: Jobs::BuildOutputs::OUTPUT_480_KEY,
            rotate: 'auto',
            segment_duration: '10',
            preset_id: Jobs::BuildOutputs::OUTPUT_480_PRESET_ID
          },
          {
            key: Jobs::BuildOutputs::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '10',
            preset_id: Jobs::BuildOutputs::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ]
      )
    end
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 720 }

    it 'should only create the low def preset' do
      expect(subject.call).to eq(
        [
          {
            key: Jobs::BuildOutputs::OUTPUT_720_KEY,
            rotate: 'auto',
            segment_duration: '10',
            preset_id: Jobs::BuildOutputs::OUTPUT_720_PRESET_ID
          },
          {
            key: Jobs::BuildOutputs::OUTPUT_480_KEY,
            rotate: 'auto',
            segment_duration: '10',
            preset_id: Jobs::BuildOutputs::OUTPUT_480_PRESET_ID
          },
          {
            key: Jobs::BuildOutputs::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '10',
            preset_id: Jobs::BuildOutputs::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ]
      )
    end
  end
end
