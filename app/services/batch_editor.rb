class BatchEditor
  include Service
  include Virtus.model

  attribute :user

  def call
    ActiveRecord::Base.transaction do
      user.activities.each do |activity|
        if activity.edits.empty?
          debug("generate_edit(#{activity.id})")
          generate_edit(activity)
        end
      end
    end
  end

  protected

  def generate_edit(activity)
    RoughCutEditor.call(activity: activity) if activity.edits.empty?
  end

  def debug(msg)
    Rails.logger.debug("BatchEditor(user: #{user.id}): #{msg}")
  end
end
