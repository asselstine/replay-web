class AddDetailsToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.string :duration, default: 0
      t.string :bitrate
      t.string :size, default: 0
      t.string :video_stream
      t.string :video_codec
      t.string :colorspace
      t.string :resolution
      t.string :width
      t.string :height
      t.string :frame_rate
      t.string :audio_stream
      t.string :audio_codec
      t.string :audio_sample_rate
      t.string :audio_channels
    end
  end
end
