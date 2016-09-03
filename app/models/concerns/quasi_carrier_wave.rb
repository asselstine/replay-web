module QuasiCarrierWave
  extend ActiveSupport::Concern

  included do
    def uploader_class
      raise 'Not implemented'
    end

    def uploader
      @uploader ||= uploader_class.new(self)
    end

    def fog
      @fog ||= CarrierWave::Storage::Fog.new(uploader)
    end

    def fog_file_from_key(path)
      CarrierWave::Storage::Fog::File.new(uploader, fog, path)
    end

    def fog_file_from_filename(file)
      fog_file_from_key(uploader.store_path(file))
    end
  end
end
