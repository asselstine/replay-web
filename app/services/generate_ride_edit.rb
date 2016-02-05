class GenerateRideEdit
  include Service
  include Virtus.model

  attribute :user
  attribute :ride

  def call
    # find recording sessions that began before the ride, and end after the ride
    new_edit = ride.edits.build(user: user)
    new_edit.build_cuts(ride.start_at, ride.end_at)
    debug("generate_ride_edit(#{ride.id}): number of cuts: #{new_edit.cuts.length}")
    if new_edit.cuts.empty?
      ride.edits.destroy(new_edit)
    else
      new_edit.save!
    end
    new_edit
  end

  protected

  def debug(msg)
    Rails.logger.debug("GenerateRideEdit(user: #{user.id}): #{msg}")
  end
end
