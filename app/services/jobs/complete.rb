module Jobs
  class Complete
    include Service
    include Virtus.model

    attribute :job, Job

    def call
      Playlists::MakePublic.call(playlist: @job.playlist) if @job.playlist
    end
  end
end
