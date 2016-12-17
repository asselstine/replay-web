# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  process :set_exif_data

  include CarrierWave::MiniMagick

  # rubocop:disable Metrics/AbcSize
  def set_exif_data
    actual_file = file.to_file
    exif = new_exif
    photo = model
    photo.filename = File.basename(current_path)
    photo.timestamp ||= exif&.date_time || actual_file.ctime
    return unless exif&.gps
    photo.exif_latitude = exif.gps.latitude
    photo.exif_longitude = exif.gps.longitude
  end

  def new_exif
    actual_file = file.to_file
    return nil unless /\.(jpg)|(jpeg)/ =~ File.extname(actual_file)
    EXIFR::JPEG.new(actual_file)
  end

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Overactivity the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :small do
    process resize_to_fill: [260, 260]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Overactivity the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details
  # def filename
  #   "something.jpg" if original_filename
  # end
  #
end
