module Streams
  class Create
    include Virtus.model
    include Service

    attribute :playlist, Playlist

    def call
      et_outputs.each do |output|
        base = filename_with_prefix(output[:key])
        attrs = { ts_key: base + '.ts',
                  playlist_key: base + '_v4.m3u8' }
        attrs[:iframe_key] = base + '_iframe.m3u8' if output[:rotate].present?
        job.playlist.streams.create!(attrs)
      end
    end

    private

    def base_attributes
    end

    def rotation_attributes
    end
  end
end
