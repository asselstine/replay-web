module Playlists
  class MakePublic
    include Virtus.model
    include Service

    attribute :playlist, Playlist

    def call
      make_playlist_public
      make_streams_public
    end

    def make_playlist_public
      S3.make_public(key: @playlist.key)
    end

    def make_streams_public
      @playlist.streams.each do |stream|
        S3.make_public(key: stream.ts_key)
        S3.make_public(key: stream.iframe_key) if stream.iframe_key.present?
        S3.make_public(key: stream.playlist_key)
      end
    end
  end
end
