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
      duration_ms: (movie.duration.to_f * 1000),
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
end
