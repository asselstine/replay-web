module Jobs
  class Read
    include Service
    include Virtus.model

    attribute :job

    def call
      response = ElasticTranscoder.client.read_job(id: @job.external_id)
      Rails.logger.debug(
        "Jobs::Read: Received Response: #{response.to_json}"
      )
      update_job(response)
      Jobs::Complete.call(job: @job) if @job.complete?
    end

    private

    def update_job(data)
      attrs = {
        status: data[:job][:output][:status].downcase,
        message: data[:job][:output][:status_detail]
      }
      update_outputs(data)
      attrs[:finished_at] = Time.zone.now if complete?(attrs[:status])
      job.update(attrs)
    end

    def update_outputs(data)
      data[:job][:outputs].each do |output_data|
        output = job.outputs.where(key: output_data[:key]).first
        next unless output
        output.update(
          duration_millis: output_data[:duration_millis],
          width: output_data[:width],
          height: output_data[:height],
          file_size: output_data[:file_size]
        )
      end
    end

    def complete?(status)
      status[/complete|canceled|error/]
    end
  end
end
