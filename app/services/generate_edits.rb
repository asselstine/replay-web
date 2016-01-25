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
    new_edit = ride.edits.build(user: user)
    new_edit.build_cuts(ride.start_at, ride.end_at)
    debug("generate_edit(#{ride.id}): number of cuts: #{new_edit.cuts.length}")
    if new_edit.cuts.empty?
      ride.edits.destroy(new_edit)
    else
      new_edit.save!
    end
  end

  def debug(msg)
    Rails.logger.debug("GenerateEdits(user: #{user.id}): #{msg}")
  end
end 
