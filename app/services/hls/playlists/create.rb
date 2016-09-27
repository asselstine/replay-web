module Playlists
  OUTPUT_1080_KEY = 'hls_8m_video'.freeze
  OUTPUT_1080_PRESET_ID = '1472655874864-22r7qm'.freeze
  OUTPUT_720_KEY = 'hls_2m_video'.freeze
  OUTPUT_720_PRESET_ID = '1472918343684-lekifi'.freeze
  OUTPUT_480_KEY = 'hls_600k_video'.freeze
  OUTPUT_480_PRESET_ID = '1472918314526-qbdv8n'.freeze
  OUTPUT_160K_AUDIO_KEY = 'hls_160k_audio'.freeze
  OUTPUT_160K_AUDIO_PRESET_ID = '1472866554076-f3ueia'.freeze
  SEGMENT_DURATION = 10

  class Create
    include Service
    include Virtus.model

    attribute :job

    def call
      create_playlist
      response = create_et_job
      job.update(external_id: response[:job][:id],
                 status: Job.statuses[:submitted],
                 started_at: Time.zone.now)
    end

    private

    def create_playlist
      playlist = job.create_playlist!(
        key: job.playlist_key
      )
      Streams::Create.call(playlist: playlist)
    end

    def create_et_job
      et_client.create_job(pipeline_id: Figaro.env.aws_et_pipeline_id,
                           input: { key: job.video.source_key },
                           output_key_prefix: job.prefix,
                           outputs: et_outputs,
                           playlists: [playlist])
    end

    def et_outputs
      @et_outputs ||= [
        output_1080,
        output_720,
        output_480,
        audio_160k
      ].compact
    end

    def playlist
      {
        format: 'HLSv4',
        name: job.output_key,
        output_keys: et_outputs.map { |output| output[:key] }
      }
    end

    def output_1080?
      false # job.video.vertical_resolution >= 1080
    end

    def output_1080
      return unless output_1080?
      {
        key: OUTPUT_1080_KEY,
        rotate: rotation,
        segment_duration: segment_duration,
        preset_id: OUTPUT_1080_PRESET_ID
      }
    end

    def output_720?
      job.video.vertical_resolution >= 720
    end

    def output_720
      return unless output_720?
      {
        key: OUTPUT_720_KEY,
        rotate: rotation,
        segment_duration: segment_duration,
        preset_id: OUTPUT_720_PRESET_ID
      }
    end

    def output_480
      {
        key: OUTPUT_480_KEY,
        rotate: rotation,
        segment_duration: segment_duration,
        preset_id: OUTPUT_480_PRESET_ID
      }
    end

    def audio_160k
      {
        key: OUTPUT_160K_AUDIO_KEY,
        segment_duration: segment_duration,
        preset_id: OUTPUT_160K_AUDIO_PRESET_ID
      }
    end

    def segment_duration
      SEGMENT_DURATION.to_s
    end

    def rotation
      return 'auto' if job.rotate_auto?
      Job.rotations[job.rotation].to_s
    end

    def et_client
      @_et_client ||=
        Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
    end
  end
end
