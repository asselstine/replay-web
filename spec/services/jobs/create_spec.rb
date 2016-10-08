require 'rails_helper'

RSpec.describe Jobs::Create do
  let(:video) do
    double(Video, vertical_resolution: vertical_resolution,
                  source_filename_no_ext: 'source_no_ext')
  end
  let(:job) do
    double(Job, id: 17,
                source_key: 'uploads/something.mp4',
                playlist_key: 'the_playlist_key',
                playlist_filename: 'filename.mp4',
                prefix: 'prefix/',
                video: video,
                rotate_elastic_transcoder_format: 'auto',
                playlist: double(id: 999))
  end
  let(:et_client) { double }
  let(:new_et_job) do
    {
      job: {
        id: 99
      }
    }
  end
  subject { Jobs::Create.new(job: job) }

  before(:each) do
    allow(subject).to receive(:et_client).and_return(et_client)
  end

  context 'when the resolution is 1080' do
    let(:vertical_resolution) { 1080 }

    let(:expected_playlist) do
      {
        format: 'HLSv4',
        name: 'source_no_ext',
        output_keys: [
          Jobs::BuildOutputs::OUTPUT_720_KEY,
          Jobs::BuildOutputs::OUTPUT_480_KEY,
          Jobs::BuildOutputs::OUTPUT_160K_AUDIO_KEY
        ]
      }
    end

    it 'should only create the low def preset' do
      expect(et_client).to receive(:create_job)
        .with(
          pipeline_id: Figaro.env.aws_et_pipeline_id,
          input: { key: 'uploads/something.mp4' },
          output_key_prefix: 'prefix/',
          outputs: anything,
          playlists: [expected_playlist]
        )
        .and_return(new_et_job)
      expect(job).to receive(:update).with(
        external_id: 99,
        status: Job.statuses[:submitted],
        started_at: an_instance_of(ActiveSupport::TimeWithZone)
      )
      expect(Playlists::Create).to receive(:call).with(
        job: job,
        et_outputs: anything
      )
      subject.call
    end
  end
end
