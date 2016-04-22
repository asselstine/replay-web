class BatchProcessor
  include Service
  include Virtus.model

  attribute :user

  def call
    ActiveRecord::Base.transaction do
      user.activities.each do |activity|
        edit_activity(activity) if activity.drafts.empty?
      end
    end
  end

  protected

  def edit_activity(activity)
    debug("edit_activity(#{activity.id})")
    Edit::ActivityVideoProcessor.call(activity: activity)
    Edit::ActivityPhotoProcessor.call(activity: activity)
  end

  def debug(msg)
    Rails.logger.debug("BatchProcessor(user: #{user.id}): #{msg}")
  end
end
