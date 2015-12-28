require 'rails_helper'

RSpec.describe RecordingSession, type: :model do

  subject { RecordingSession.new }

  describe '#name' do
    it 'should set the name of the session' do
      subject.name = 'foo'
      expect(subject.name).to eq 'foo'
    end
  end
end
