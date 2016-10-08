require 'rails_helper'

RSpec.describe Playlists::MakePublic do
  subject do
    Playlists::MakePublic.new(
      playlist: playlist
    )
  end

  let(:playlist) { double(Playlist, key: 'asdf', streams: [stream]) }
  let(:stream) do
    double(Stream,
           ts_key: ts_key,
           iframe_key: iframe_key,
           playlist_key: playlist_key)
  end
  let(:ts_key) { 'ts' }
  let(:iframe_key) { 'iframe' }
  let(:playlist_key) { 'playlist' }

  it 'should call s3 on all keys' do
    expect(S3).to receive(:make_public).with(key: 'asdf')
    expect(S3).to receive(:make_public).with(key: ts_key)
    expect(S3).to receive(:make_public).with(key: iframe_key)
    expect(S3).to receive(:make_public).with(key: playlist_key)
    subject.call
  end

  context 'when no iframe present' do
    let(:iframe_key) { nil }

    it 'should call without iframe' do
      expect(S3).to receive(:make_public).with(key: 'asdf')
      expect(S3).to receive(:make_public).with(key: ts_key)
      expect(S3).to receive(:make_public).with(key: playlist_key)
      subject.call
    end
  end
end
