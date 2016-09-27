require 'rails_helper'

RSpec.describe Jobs::Create do
  let(:video) do
    double(Video, vertical_resolution: vertical_resolution,
                  source_filename_no_ext: 'source_no_ext')
  end
  let(:rotate_auto) { false }
  let(:job) do
    double(Job, id: 17,
                source_key: 'uploads/something.mp4',
                playlist_key: 'the_playlist_key',
                playlist_filename: 'filename.mp4',
                prefix: 'prefix/',
                video: video,
                rotate_auto?: rotate_auto,
                rotation: :rotate_0,
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
    expect(job).to receive(:create_playlist!)
      .with(key: 'the_playlist_key').and_return(:playlist)
    expect(Streams::Create).to receive(:call).with(playlist: :playlist,
                                                   et_outputs: anything)
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 480 }
    let(:rotate_auto) { true }

    it 'should only create the low def preset' do
      expect_create_job_with_outputs(
        [
          {
            key: Jobs::Create::OUTPUT_480_KEY,
            rotate: 'auto',
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_480_PRESET_ID
          },
          {
            key: Jobs::Create::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            Jobs::Create::OUTPUT_480_KEY,
            Jobs::Create::OUTPUT_160K_AUDIO_KEY
          ]
        )
      )
      expect_update
      subject.call
    end
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 720 }

    it 'should only create the low def preset' do
      expect_create_job_with_outputs(
        [
          {
            key: Jobs::Create::OUTPUT_720_KEY,
            rotate: '0',
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_720_PRESET_ID
          },
          {
            key: Jobs::Create::OUTPUT_480_KEY,
            rotate: '0',
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_480_PRESET_ID
          },
          {
            key: Jobs::Create::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            Jobs::Create::OUTPUT_720_KEY,
            Jobs::Create::OUTPUT_480_KEY,
            Jobs::Create::OUTPUT_160K_AUDIO_KEY
          ]
        )
      )
      expect_update
      subject.call
    end
  end

  context 'when the resolution is 1080' do
    let(:vertical_resolution) { 1080 }

    it 'should only create the low def preset' do
      expect_create_job_with_outputs(
        [
          # {
          #   key: Jobs::Create::OUTPUT_1080_KEY,
          #   rotate: '0',
          #   segment_duration: '10',
          #   preset_id: Jobs::Create::OUTPUT_1080_PRESET_ID
          # },
          {
            key: Jobs::Create::OUTPUT_720_KEY,
            rotate: '0',
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_720_PRESET_ID
          },
          {
            key: Jobs::Create::OUTPUT_480_KEY,
            rotate: '0',
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_480_PRESET_ID
          },
          {
            key: Jobs::Create::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '10',
            preset_id: Jobs::Create::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            # Jobs::Create::OUTPUT_1080_KEY,
            Jobs::Create::OUTPUT_720_KEY,
            Jobs::Create::OUTPUT_480_KEY,
            Jobs::Create::OUTPUT_160K_AUDIO_KEY
          ]
        )
      )
      expect_update
      subject.call
    end
  end

  def playlist(output_keys)
    {
      format: 'HLSv4',
      name: 'source_no_ext',
      output_keys: output_keys
    }
  end

  def expect_update
    expect(job).to receive(:update).with(
      external_id: 99,
      status: Job.statuses[:submitted],
      started_at: an_instance_of(ActiveSupport::TimeWithZone)
    )
  end

  def expect_create_job_with_outputs(outputs, playlist:)
    expect(et_client).to receive(:create_job)
      .with(
        pipeline_id: Figaro.env.aws_et_pipeline_id,
        input: { key: 'uploads/something.mp4' },
        output_key_prefix: 'prefix/',
        outputs: outputs,
        playlists: [playlist]
      )
      .and_return(new_et_job)
  end
end
