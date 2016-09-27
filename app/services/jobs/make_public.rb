module Jobs
  class MakePublic
    include Virtus.model
    include Service

    attribute :job, Job

    def call
      make_playlist_public
      make_streams_public
    end

    def make_playlist_public
      S3.make_public(@job.playlist_key)
    end

    def make_streams_public
      @job.playlist.streams.each do |stream|
        S3.make_public(stream.ts_key)
        S3.make_public(stream.iframe_key) if stream.iframe_key.present?
        S3.make_public(stream.playlist_key)
      end
    end
  end
end
