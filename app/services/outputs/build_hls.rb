module Outputs
  class BuildHls
    OUTPUT_1080_KEY = 'hls_8m_video'.freeze
    OUTPUT_1080_PRESET_ID = '1472655874864-22r7qm'.freeze
    OUTPUT_720_KEY = 'hls_2m_video'.freeze
    OUTPUT_720_PRESET_ID = '1472918343684-lekifi'.freeze
    OUTPUT_480_KEY = 'hls_600k_video'.freeze
    OUTPUT_480_PRESET_ID = '1472918314526-qbdv8n'.freeze
    OUTPUT_160K_AUDIO_KEY = 'hls_160k_audio'.freeze
    OUTPUT_160K_AUDIO_PRESET_ID = '1472866554076-f3ueia'.freeze
    SEGMENT_DURATION = 10

    include Service
    include Virtus.model

    attribute :job, Job

    def call
      [
        output_720,
        output_480,
        audio_160k
      ].compact
    end

    private

    def output_720?
      @job.video.vertical_resolution >= 720
    end

    def output_720
      return unless output_720?
      job.outputs.build(
        key: OUTPUT_720_KEY,
        preset_id: OUTPUT_720_PRESET_ID,
        segment_duration: SEGMENT_DURATION,
        media_type: :video
      )
    end

    def output_480
      job.outputs.build(
        key: OUTPUT_480_KEY,
        preset_id: OUTPUT_480_PRESET_ID,
        segment_duration: SEGMENT_DURATION,
        media_type: :video
      )
    end

    def audio_160k
      job.outputs.build(
        key: OUTPUT_160K_AUDIO_KEY,
        preset_id: OUTPUT_160K_AUDIO_PRESET_ID,
        segment_duration: SEGMENT_DURATION,
        media_type: :audio
      )
    end
  end
end
