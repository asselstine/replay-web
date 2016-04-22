require 'rails_helper'

RSpec.describe KMLOutput do
  let(:activity) { create(:activity) }
  let(:context) { Frame.new }
  let(:activity_evaluator) { UserEvaluator.new(activity: activity, context: context) }

  subject { KMLOutput.new(activity_evaluator: activity_evaluator) }

  it 'should return the empty file' do
    #expect(subject.call).to include '<kml'
  end
end
