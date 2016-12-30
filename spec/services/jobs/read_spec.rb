require 'rails_helper'

RSpec.describe Jobs::Read do
  let(:complete?) { false }
  let(:job) do
    double(Job, video: :video,
                playlist: playlist,
                external_id: 99,
                complete?: complete?,
                outputs: outputs)
  end
  let(:outputs) { [output] }
  let(:output) { double(Output) }
  let(:playlist) { double(Playlist) }
  let(:client) { double }
  subject { Jobs::Read.new(job: job) }

  let(:et_job) do
    {
      job: {
        output: {
          status: et_job_status,
          status_detail: 'status detail'
        },
        outputs: [
          {
            key: 'asdf',
            duration_millis: 1001,
            width: 320,
            height: 480,
            file_size: 1234
          }
        ]
      }
    }
  end

  before(:each) do
    allow(ElasticTranscoder).to receive(:client).and_return(client)
    allow(client).to receive(:read_job).with(id: 99).and_return(et_job)
    expect(job).to receive(:output_for_key).with('asdf').and_return(output)
    expect(output).to receive(:update).with(
      duration_millis: 1001,
      width: 320,
      height: 480,
      file_size: 1234
    )
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
      expect(Jobs::Complete).to receive(:call).with(job: job)
      subject.call
    end
  end
end
