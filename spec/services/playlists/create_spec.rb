RSpec.describe Playlists::Create do
  subject do
    Playlists::Create.new(job: job, et_outputs: et_outputs)
  end

  let(:job) { double(Job, playlist_key: 'pkey') }
  let(:et_outputs) do
    [
      {
        key: 'asdf',
        rotate: rotate
      }
    ]
  end
  let(:rotate) { '1234' }
  let(:playlist) { double(Playlist, streams: streams) }
  let(:streams) { double(ActiveRecord::Relation) }

  it 'should create the playlist and stream' do
    expect(job).to receive(:create_playlist!)
      .with(key: 'pkey').and_return(playlist)
    expect(job).to receive(:filename_with_prefix)
      .with('asdf').and_return('1080p')
    expect(streams).to receive(:create!)
      .with(ts_key: '1080p.ts',
            playlist_key: '1080p_v4.m3u8',
            iframe_key: '1080p_iframe.m3u8')
    expect(subject.call).to eq(playlist)
  end

  context 'when no rotate, it must be audio' do
    let(:rotate) { nil }

    it 'should create the playlist and audio stream' do
      expect(job).to receive(:create_playlist!)
        .with(key: 'pkey').and_return(playlist)
      expect(job).to receive(:filename_with_prefix)
        .with('asdf').and_return('audio')
      expect(streams).to receive(:create!)
        .with(ts_key: 'audio.ts',
              playlist_key: 'audio_v4.m3u8')
      expect(subject.call).to eq(playlist)
    end
  end
end
