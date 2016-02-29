class EditProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(edit:)
    if Rails.env.test?
      EditProcessor.new(edit: edit).call
    else
      RemoteEditProcessor.new(edit: edit).call
    end
  end
end
