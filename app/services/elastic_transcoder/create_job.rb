module ElasticTranscoder
  class CreateJob
    include Virtus.model
    include Service

    attribute :job

    def call
      ElasticTranscoder.client.create_job(
        pipeline_id: Figaro.env.aws_et_pipeline_id,
        input: { key: @job.source_key },
        output_key_prefix: @job.prefix,
        outputs: outputs,
        playlists: playlists
      )
    end

    private

    def playlists
      return [] unless @job.playlist.present?
      [
        {
          format: 'HLSv4',
          name: @job.video.source_filename_no_ext,
          output_keys: @job.outputs.map(&:key)
        }
      ]
    end

    def outputs
      @job.outputs.map do |output|
        attrs = {
          key: output.key,
          rotate: @job.rotate_elastic_transcoder_format,
          preset_id: output.preset_id
        }
        if output.segment_duration
          attrs[:segment_duration] = output.segment_duration
        end
        if output.thumbnail_pattern
          attrs[:thumbnail_pattern] = output.thumbnail_pattern
        end
        attrs
      end
    end
  end
end
