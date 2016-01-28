require 'rails_helper'

describe SnsController, type: :controller do

  let(:confirm_subscription_response) do
    {
      "Type" => "SubscriptionConfirmation", 
      "MessageId" => "4bd5281c-c79a-45ca-a9f7-c3f350187fea", 
      "Token" => "token", 
      "TopicArn" => "blah",
      "Message" => "You have chosen to subscribe blah blah",
      "SubscribeURL" => "URL", 
      "Timestamp" => "2016-01-28T04:29:04.205Z", 
      "SignatureVersion" => "1", 
      "Signature" => "siggg", 
      "SigningCertURL" => "some url"
    }
  end

  let(:verifier) { double }
  let(:topic) { double }

  it 'should create a new topic and confirm the subscription' do
    msg = confirm_subscription_response

    expect(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
    expect(verifier).to receive(:authentic?).with(msg.to_json).and_return(true)

    expect(Aws::SNS::Topic).to receive(:new).and_return(topic)
    expect(topic).to receive(:confirm_subscription).with(token: 'token')

    post :message, msg.to_json
  end

end
