module Playlists
  class Create
    include Service
    include Virtus.model

    attribute :job, Job
    attribute :outputs, Array[Output]

    def call
      playlist = @job.create_playlist!(key: @job.playlist_key)
      create_streams(playlist)
      playlist
    end

    private

    def create_streams(playlist)
      @outputs.each do |output|
        base = @job.filename_with_prefix(output.key)
        attrs = { ts_key: base + '.ts',
                  playlist_key: base + '_v4.m3u8' }
        attrs[:iframe_key] = base + '_iframe.m3u8' if output.video?
        playlist.streams.create!(attrs)
      end
    end
  end
end
