module HlsJobs
  OUTPUT_1080_KEY = 'hls_8m_video'.freeze
  OUTPUT_1080_PRESET_ID = '1472655874864-22r7qm'.freeze
  OUTPUT_720_KEY = 'hls_2m_video'.freeze
  OUTPUT_720_PRESET_ID = '1472656168913-y3nhcl'.freeze
  OUTPUT_480_KEY = 'hls_600k_video'.freeze
  OUTPUT_480_PRESET_ID = '1472656304236-dx5pqj'.freeze
  OUTPUT_160K_AUDIO_KEY = 'hls_160k_audio'.freeze
  OUTPUT_160K_AUDIO_PRESET_ID = '1351620000001-200060'.freeze
  SEGMENT_DURATION = 2 # two second duration for tight segments

  class Create
    include Service
    include Virtus.model

    attribute :job

    def call
      response = create_et_job
      job.update(external_id: response[:job][:id],
                 status: Job.statuses[:submitted],
                 key: "#{output_key_prefix}#{output_key}.m3u8",
                 started_at: Time.zone.now)
    end

    private

    def output_key_prefix
      "hls/job-#{job.id}/"
    end

    def output_key
      File.basename(job.video.source_key, File.extname(job.video.source_key))
    end

    def create_et_job
      et_client.create_job(pipeline_id: Figaro.env.aws_et_pipeline_id,
                           input: { key: job.video.source_key },
                           output_key_prefix: output_key_prefix,
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
        name: output_key,
        output_keys: et_outputs.map { |output| output[:key] }
      }
    end

    def output_1080?
      job.video.vertical_resolution >= 1080
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
