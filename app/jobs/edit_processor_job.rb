class EditProcessorJob < ActiveJob::Base
  queue_as :default

  def perform(edit:)
    if edit.cuts.empty?
      Rails.logger.debug('EditProcessorJob: ignoring: Edit #{edit.id} is empty')
      return
    end

    if Rails.env.test?
      EditProcessor.new(edit: edit).call
    else
      RemoteEditProcessor.new(edit: edit).call
    end
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
