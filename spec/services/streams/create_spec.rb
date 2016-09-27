RSpec.describe Streams::Create do
  subject do
    Streams::Create.new(playlist: playlist)
  end

  let(:playlist) do
    double(Playlist)
  end

  let(:streams) do
    double
  end

  before(:each) do
    allow(playlist).to receive(:streams).and_return(streams)
  end

  it 'should create the streams' do
    expect(subject.call).to be_truthy
  end
end
