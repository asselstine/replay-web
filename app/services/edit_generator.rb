class GenerateEdits
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
    # find recording sessions that began before the ride, and end after the ride
    edit = ride.edits.build(user: user)
    edit.build_cuts(ride.start_at, ride.end_at)
    debug("generate_edit(#{ride.id}): number of cuts: #{edit.cuts.length}")
    if edit.cuts.empty?
      ride.edits.destroy(edit)
    else
      edit.save
    end
  end

  def debug(msg)
    Rollbar.debug("GenerateEdits(user: #{user.id}): #{msg}")
  end
end
