module Jobs
  class Complete
    include Service
    include Virtus.model

    attribute :job, Job

    def call
      Playlists::MakePublic.call(playlist: @job.playlist) if @job.playlist
      job.outputs.each do |output|
        make_thumbnails_public(output) if output.thumbnail_pattern
      end
    end

    private

    def make_thumbnails_public(output)
      output.thumbnail_keys.each do |key|
        S3.make_public(key: job.full_key(key))
      end
    end
  end
end
