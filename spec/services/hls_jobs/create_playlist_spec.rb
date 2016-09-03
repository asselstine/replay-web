require 'rails_helper'

RSpec.describe HlsJobs::CreatePlaylist do
  let(:video) do
    double(Video, vertical_resolution: vertical_resolution,
                  source_key: 'uploads/something.mp4')
  end
  let(:job) do
    double(Job, id: 17,
                video: video,
                rotate_auto?: false,
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
  subject { HlsJobs::CreatePlaylist.new(job: job) }

  before(:each) do
    allow(subject).to receive(:et_client).and_return(et_client)
    expect(job).to receive(:create_playlist!)
      .with(file: 'something.m3u8')
  end

  context 'when the resolution is 720' do
    let(:vertical_resolution) { 480 }

    it 'should only create the low def preset' do
      expect_create_job_with_outputs(
        [
          {
            key: HlsJobs::OUTPUT_480_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_480_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            HlsJobs::OUTPUT_480_KEY,
            HlsJobs::OUTPUT_160K_AUDIO_KEY
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
            key: HlsJobs::OUTPUT_720_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_720_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_480_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_480_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            HlsJobs::OUTPUT_720_KEY,
            HlsJobs::OUTPUT_480_KEY,
            HlsJobs::OUTPUT_160K_AUDIO_KEY
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
          {
            key: HlsJobs::OUTPUT_1080_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_1080_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_720_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_720_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_480_KEY,
            rotate: '0',
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_480_PRESET_ID
          },
          {
            key: HlsJobs::OUTPUT_160K_AUDIO_KEY,
            segment_duration: '2',
            preset_id: HlsJobs::OUTPUT_160K_AUDIO_PRESET_ID
          }
        ],
        playlist: playlist(
          [
            HlsJobs::OUTPUT_1080_KEY,
            HlsJobs::OUTPUT_720_KEY,
            HlsJobs::OUTPUT_480_KEY,
            HlsJobs::OUTPUT_160K_AUDIO_KEY
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
      name: 'something',
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
        output_key_prefix: 'hls/playlist-999/',
        outputs: outputs,
        playlists: [playlist]
      )
      .and_return(new_et_job)
  end
end
