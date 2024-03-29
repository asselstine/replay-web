RSpec.describe Playlists::Create do
  subject do
    Playlists::Create.new(job: job, outputs: outputs)
  end

  let(:job) { double(Job, playlist_key: 'pkey') }
  let(:outputs) do
    [
      Output.new(key: 'asdf', media_type: media_type)
    ]
  end
  let(:media_type) { :video }
  let(:playlist) { double(Playlist, streams: streams) }
  let(:streams) { double(ActiveRecord::Relation) }

  it 'should create the playlist and stream' do
    expect(job).to receive(:create_playlist!)
      .with(key: 'pkey').and_return(playlist)
    expect(job).to receive(:full_key)
      .with('asdf').and_return('1080p')
    expect(streams).to receive(:create!)
      .with(ts_key: '1080p.ts',
            playlist_key: '1080p_v4.m3u8',
            iframe_key: '1080p_iframe.m3u8')
    expect(subject.call).to eq(playlist)
  end

  context 'for audio type' do
    let(:media_type) { :audio }

    it 'should create the playlist and audio stream' do
      expect(job).to receive(:create_playlist!)
        .with(key: 'pkey').and_return(playlist)
      expect(job).to receive(:full_key)
        .with('asdf').and_return('audio')
      expect(streams).to receive(:create!)
        .with(ts_key: 'audio.ts',
              playlist_key: 'audio_v4.m3u8')
      expect(subject.call).to eq(playlist)
    end
  end
end
