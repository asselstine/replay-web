# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base
  process :video_metadata

  def video_metadata
    cache_stored_file! unless cached?
    movie = FFMPEG::Movie.new(current_path)
    fail 'video_metadata: invalid movie' unless movie.valid?
    model.update(
      filename: File.basename(current_path),
      duration: movie.duration,
      bitrate: movie.bitrate,
      size: movie.size,
      video_stream: movie.video_stream,
      video_codec: movie.video_codec,
      colorspace: movie.colorspace,
      resolution: movie.resolution,
      width: movie.width,
      height: movie.height,
      frame_rate: movie.frame_rate,
      audio_stream: movie.audio_stream,
      audio_codec: movie.audio_codec,
      audio_sample_rate: movie.audio_sample_rate,
      audio_channels: movie.audio_channels
    )
  end

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
