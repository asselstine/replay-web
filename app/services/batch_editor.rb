class BatchEditor
  include Service
  include Virtus.model

  attribute :user

  def call
    ActiveRecord::Base.transaction do
      user.rides.each do |ride|
        if ride.edits.empty?
          debug("generate_edit(#{ride.id})")
          generate_edit(ride)
        end
      end
    end
  end

  protected

  def generate_edit(ride)
    RoughCutEditor.call(ride: ride) if ride.edits.empty?
  end

  def debug(msg)
    Rails.logger.debug("BatchEditor(user: #{user.id}): #{msg}")
  end
end
