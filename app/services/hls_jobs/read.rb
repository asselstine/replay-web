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
      check_playlist
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

    def complete?(status)
      status[/complete|canceled|error/]
    end

    def check_playlist
      return unless job.complete?
      Playlist.create!(video: job.video, key: job.key)
    end

    def et_client
      @_et_client ||=
        Aws::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
    end
  end
end
