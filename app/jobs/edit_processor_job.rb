class EditProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(video_edit:)
    if Rails.env.test?
      EditProcessor.new(video_edit: video_edit).call
    else
      RemoteEditProcessor.new(video_edit: video_edit).call
    end
  end
end
