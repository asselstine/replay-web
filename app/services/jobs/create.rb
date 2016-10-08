module Jobs
  class Create
    include Service
    include Virtus.model

    attribute :job

    def call
      create_job
      Playlists::Create.call(job: job,
                             et_outputs: outputs)
    end

    private

    def outputs
      @outputs ||= Jobs::BuildOutputs.call(
        video: job.video,
        rotation: job.rotate_elastic_transcoder_format
      )
    end

    def create_job
      response = create_et_job
      job.update(external_id: response[:job][:id],
                 status: Job.statuses[:submitted],
                 started_at: Time.zone.now)
    end

    def create_et_job
      et_client.create_job(pipeline_id: Figaro.env.aws_et_pipeline_id,
                           input: { key: job.source_key },
                           output_key_prefix: job.prefix,
                           outputs: outputs,
                           playlists: [playlist])
    end

    def playlist
      {
        format: 'HLSv4',
        name: job.video.source_filename_no_ext,
        output_keys: outputs.map { |output| output[:key] }
      }
    end

    def et_client
      @_et_client ||=
        Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
    end
  end
end
