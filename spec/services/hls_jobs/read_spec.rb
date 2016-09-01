require 'rails_helper'

RSpec.describe HlsJobs::Read do
  let(:complete?) { false }
  let(:job) { double(Job, video: :video, key: :key, external_id: 99, complete?: complete?) }
  let(:et_client) { double }
  subject { HlsJobs::Read.new(job: job) }

  let(:et_job) do
    {
      job: {
        output: {
          status: et_job_status,
          status_detail: 'status detail'
        }
      }
    }
  end

  before(:each) do
    allow(subject).to receive(:et_client).and_return(et_client)
    allow(et_client).to receive(:read_job).with(id: 99).and_return(et_job)
  end

  context 'when progressing' do
    let(:et_job_status) { 'Progressing' }
    it 'should update a job status and message' do
      expect(job).to receive(:update)
        .with(
          status: 'progressing',
          message: 'status detail'
        )
      subject.call
    end
  end

  context 'when failed' do
    let(:et_job_status) { 'Error' }
    it 'should update a job status, message, and finished_at' do
      expect(job).to receive(:update)
        .with(
          status: 'error',
          message: 'status detail',
          finished_at: an_instance_of(ActiveSupport::TimeWithZone)
        )
      subject.call
    end
  end

  context 'when complete' do
    let(:et_job_status) { 'Complete' }
    let(:complete?) { true }
    it 'should update the job and create a new playlist' do
      expect(job).to receive(:update)
        .with(
          status: 'complete',
          message: 'status detail',
          finished_at: an_instance_of(ActiveSupport::TimeWithZone)
        )
      expect(Playlist).to receive(:create!)
        .with(video: :video,
              key: :key)
      subject.call
    end
  end
end
