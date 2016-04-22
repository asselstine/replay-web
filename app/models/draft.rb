class Draft < ActiveRecord::Base
  belongs_to :setup
  belongs_to :activity
  belongs_to :upload

  validates_presence_of :setup, :activity, :upload, :start_at, :end_at

  after_create :slice_draft

  def slice_draft
    DraftSlicerJob.perform_later(draft_id: id)
  end
end
