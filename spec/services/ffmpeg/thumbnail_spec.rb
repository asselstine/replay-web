require 'rails_helper'

RSpec.describe FFMPEG::Thumbnail do
  let(:video) do
    double(Video, id: 1, filename: 'dan_session-1.mp4', user: :user)
  end
  let(:time_ms) { 0 }
  subject { FFMPEG::Thumbnail.new(video: video, time_ms: time_ms) }

  it 'should cache the file then run the correct command' do
    video_path = subject.cached_video_filepath(video)
    image_path = subject.image_path
    expect(subject).to receive(:cache_video).with(video)
    expect(subject).to receive(:run)
      .with("ffmpeg -ss 00:00:00.000 -i #{video_path} -vframes 1 #{image_path}")
    expect(File).to receive(:new).with(image_path).and_return(:file)
    expect(video).to receive(:create_thumbnail!).with(image: :file, user: :user)
    expect(video).to receive(:save!)
    subject.call
  end
end
