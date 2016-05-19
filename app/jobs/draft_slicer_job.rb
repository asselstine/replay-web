class DraftSlicerJob < ActiveJob::Base
  queue_as :default

  def perform(draft_id:)
    Edit::DraftSlicer.call(draft: Draft.find(draft_id))
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
