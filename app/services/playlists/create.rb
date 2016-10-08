module Playlists
  class Create
    include Service
    include Virtus.model

    attribute :job, Job
    attribute :et_outputs, Array[Hash]

    def call
      playlist = create_playlist
      create_streams(playlist)
      playlist
    end

    private

    def create_playlist
      job.create_playlist!(key: job.playlist_key)
    end

    def create_streams(playlist)
      et_outputs.each do |output|
        base = job.filename_with_prefix(output[:key])
        attrs = { ts_key: base + '.ts',
                  playlist_key: base + '_v4.m3u8' }
        attrs[:iframe_key] = base + '_iframe.m3u8' if output[:rotate].present?
        playlist.streams.create!(attrs)
      end
    end
  end
end
