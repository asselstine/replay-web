class DraftSlicerJob < ActiveJob::Base
  queue_as :default

  def perform(draft_id)
    FFMPEG::DraftSlicer.call(draft: Draft.find(draft_id))
  end
end
