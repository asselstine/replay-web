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
    edit = Edit.new(user: user, ride: ride)
    Editor.call(edit: edit)
  end

  def debug(msg)
    Rollbar.debug("BatchEditor(user: #{user.id}): #{msg}")
  end
end
