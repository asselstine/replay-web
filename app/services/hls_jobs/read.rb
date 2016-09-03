module HlsJobs
  class Read
    include Service
    include Virtus.model

    attribute :job

    def call
      response = et_client.read_job(id: job.external_id)
      Rails.logger.debug(
        "HlsJobs::Read: Received Response: #{response.to_json}"
      )
      update_job(response)
      complete_job if job.complete?
    end

    private

    def update_job(data)
      attrs = {
        status: data[:job][:output][:status].downcase,
        message: data[:job][:output][:status_detail]
      }
      attrs[:finished_at] = Time.zone.now if complete?(attrs[:status])
      job.update(attrs)
    end

    def complete_job
      S3.make_public(job.playlist.key)
      job.playlist.streams.each do |stream|
        S3.make_public(stream.ts_key)
        S3.make_public(stream.iframe_key) if stream.iframe_key.present?
        S3.make_public(stream.playlist_key)
      end
    end

    def complete?(status)
      status[/complete|canceled|error/]
    end

    def et_client
      @_et_client ||=
        Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
    end
  end
end
