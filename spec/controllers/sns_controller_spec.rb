require 'rails_helper'

describe SnsController, type: :controller do
  let(:confirm_subscription_response) do
    {
      'Type' => 'SubscriptionConfirmation',
      'MessageId' => '4bd5281c-c79a-45ca-a9f7-c3f350187fea',
      'Token' => 'token',
      'TopicArn' => 'blah',
      'Message' => 'You have chosen to subscribe blah blah',
      'SubscribeURL' => 'URL',
      'Timestamp' => '2016-01-28T04:29:04.205Z',
      'SignatureVersion' => '1',
      'Signature' => 'siggg',
      'SigningCertURL' => 'some url'
    }
  end

  # rubocop:disable Metrics/LineLength
  let(:transcoding_notification) do
    {
      'Type' => 'Notification',
      'MessageId' => '2c69da00-8d95-5f60-97e7-95232c9dd542',
      'TopicArn' => 'arn:asldkf',
      'Subject' => 'Amazon Elastic Transcoder has finished transcoding job 1453956797956-5ci8ub.',
      'Message' => %({\n  \"state\" : \"COMPLETED\",\n  \"version\" : \"2012-09-25\",\n  \"jobId\" : \"1453956797956-5ci8ub\",\n  \"pipelineId\" : \"1452987074877-kgud8g\",\n  \"input\" : {\n    \"key\" : \"uploads/1453956795016-ky46vh41i3323xr-534ff8c274a8059a991f461c01d0476d/dan_session1-frame.mp4\"\n  },\n  \"outputKeyPrefix\" : \"et/\",\n  \"outputs\" : [ {\n    \"id\" : \"1\",\n    \"presetId\" : \"1351620000001-100240\",\n    \"key\" : \"webm/46ef9687dc7a3deddc5add02b3c361f7efbd3748ff82eb9dae8968e56d5bd40f.webm\",\n    \"status\" : \"Complete\",\n    \"duration\" : 1,\n    \"width\" : 640,\n    \"height\" : 360\n  }, {\n    \"id\" : \"2\",\n    \"presetId\" : \"1351620000001-100070\",\n    \"key\" : \"mp4/46ef9687dc7a3deddc5add02b3c361f7efbd3748ff82eb9dae8968e56d5bd40f.mp4\",\n    \"status\" : \"Complete\",\n    \"duration\" : 1,\n    \"width\" : 640,\n    \"height\" : 360\n  } ]\n}),
      'Timestamp' => '2016-01-28T04:53:28.573Z',
      'SignatureVersion' => '1',
      'Signature' => 'siggg',
      'SigningCertURL' => 'certURL',
      'UnsubscribeURL' => 'unsubURL'
    }
  end

  let(:verifier) { double }
  let(:topic) { double }

  def expect_verify_with(body)
    expect(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
    expect(verifier).to receive(:authentic?).with(body)
  end

  it 'should create a new topic and confirm the subscription' do
    msg = confirm_subscription_response
    expect_verify_with(msg.to_json).and_return(true)
    expect(Aws::SNS::Topic).to receive(:new).and_return(topic)
    expect(topic).to receive(:confirm_subscription).with(token: 'token')
    post :message, msg.to_json
  end

  it 'should update video when the transcoding is finished' do
    msg = transcoding_notification
    expect_verify_with(msg.to_json).and_return(true)
    video = double(Video)
    expect(Video).to receive(:where).with(job_id: '1453956797956-5ci8ub').and_return([video])
    expect(video).to receive(:update_et)
    post :message, msg.to_json
  end
end
