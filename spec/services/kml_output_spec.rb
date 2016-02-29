require 'rails_helper'

RSpec.describe KMLOutput do
  let(:user) { create(:user) }
  let(:context) { Frame.new }
  let(:user_evaluator) { UserEvaluator.new(user: user, context: context) }

  subject { KMLOutput.new(user_evaluator: user_evaluator) }

  it 'should return the empty file' do
    #expect(subject.call).to include '<kml' 
  end
end

