require 'rails_helper'

RSpec.describe Jobs::Start do
  subject { Jobs::Start.new(job: job) }

  let(:job) do
    Job.new(output_type: output_type)
  end

  context 'for hls' do
    let(:output_type) { :hls }

    it 'should create HLS outputs and playlist' do
      expect(Outputs::BuildHls).to receive(:call).with(job: job)
      expect(Playlists::Create).to receive(:call).with(job: job)
      expect(ElasticTranscoder::CreateJob).to receive(:call)
        .with(job: job)
        .and_return(
          job: {
            id: 1
          }
        )
      expect(job).to receive(:update)
        .with(external_id: 1,
              status: Job.statuses[:submitted],
              started_at: an_instance_of(ActiveSupport::TimeWithZone))
      subject.call
    end
  end

  context 'for web' do
    let(:output_type) { :web }

    it 'should create HLS outputs and playlist' do
      expect(Outputs::BuildWeb).to receive(:call).with(job: job)
      expect(ElasticTranscoder::CreateJob).to receive(:call)
        .with(job: job)
        .and_return(
          job: {
            id: 1
          }
        )
      expect(job).to receive(:update)
        .with(external_id: 1,
              status: Job.statuses[:submitted],
              started_at: an_instance_of(ActiveSupport::TimeWithZone))
      subject.call
    end
  end
end
