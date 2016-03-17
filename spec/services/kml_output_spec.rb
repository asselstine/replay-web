require 'rails_helper'

RSpec.describe KMLOutput do
  let(:ride) { create(:ride) }
  let(:context) { Frame.new }
  let(:ride_evaluator) { UserEvaluator.new(ride: ride, context: context) }

  subject { KMLOutput.new(ride_evaluator: ride_evaluator) }

  it 'should return the empty file' do
    #expect(subject.call).to include '<kml'
  end
end
