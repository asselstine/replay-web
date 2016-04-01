class GenerateRideEdit
  include Service
  include Virtus.model

  attribute :user
  attribute :ride

  def call
    # find recording sessions that began before the ride, and end after the ride
    edit = ride.edits.build(user: user)
    edit.build_cuts(ride.start_at, ride.end_at)
    debug("generate_ride_edit(#{ride.id}): number of cuts: #{edit.cuts.length}")
    if edit.cuts.empty?
      ride.edits.destroy(edit)
    else
      edit.save!
    end
  end

  protected

  def debug(msg)
    Rails.logger.debug("GenerateRideEdit(user: #{user.id}): #{msg}")
  end
end
