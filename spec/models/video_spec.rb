require 'rails_helper'

RSpec.describe Video do
  let(:now) { DateTime.now }
  def time(seconds)
    now.since(seconds)
  end

  subject { create(:video, job_id: 12, source_key: 'foo') }

  describe '#update_et' do
    let(:et_client) { double(AWS::ElasticTranscoder::Client) }
    
    it 'should update the attributes to match the JSON' do
      expect(subject).to receive(:et_client).and_return(et_client)
      expect(et_client).to receive(:read_job).with({ id: '12' }).and_return(
        double(AWS::Core::Response, data: {
          job: {
            id: 1234,
            output: {
              duration: 2,
              status: Video::STATUS_SUBMITTED,
              status_detail: 'This video is submitted'
            }
          }
        })
      )
      subject.update_et
      expect(subject.status).to eq(Video::STATUS_SUBMITTED)
      expect(subject.message).to eq('This video is submitted')
      expect(subject.duration_ms).to eq(2000)
    end 
  end

  context 'class' do
    subject { Video }

    describe '#during' do
      let(:start_at) { time(0) }
      let(:end_at) { time(5) }
      let(:video) { create(:video, start_at: start_at, end_at: end_at) }

      def during(start_at, end_at)
        expect(subject.during(start_at, end_at))
      end

      context 'video is within the tick' do
        it { during(time(-1),time(0)).to_not include(video) }
        it { during(time(-1),time(1)).to include(video) }
        it { during(time(0), time(1)).to include(video) }
        it { during(time(2), time(3)).to include(video) }
        it { during(time(5), time(6)).to_not include(video) }
      end 
    end
  end
end
