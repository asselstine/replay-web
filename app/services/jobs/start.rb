module Jobs
  class Start
    include Service
    include Virtus.model

    attribute :job

    def call
      if @job.hls?
        Outputs::BuildHls.call(job: @job)
        Playlists::Create.call(job: @job)
      else
        Outputs::BuildWeb.call(job: @job)
      end
      start_job
    end

    private

    def start_job
      response = ElasticTranscoder::CreateJob.call(job: @job)
      @job.update(external_id: response[:job][:id],
                  status: Job.statuses[:submitted],
                  started_at: Time.zone.now)
    end
  end
end
