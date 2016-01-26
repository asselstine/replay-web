class RecordingSessionJob < ActiveJob::Base
  queue_as :default

  def perform(edit)
    # Do something later
    RemoteCutter.new(edit: edit).call
  end
end
