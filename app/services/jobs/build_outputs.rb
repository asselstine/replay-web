module Jobs
  class BuildOutputs
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

    attribute :video, Video
    attribute :rotation, String

    def call
      @et_outputs ||= [
        output_1080,
        output_720,
        output_480,
        audio_160k
      ].compact
    end

    private

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
      video.vertical_resolution >= 720
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
  end
end
