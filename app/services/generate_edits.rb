class GenerateEdits
  include Service
  include Virtus.model

  attribute :user

  def call
    ActiveRecord::Base.transaction do
      user.rides.each do |ride|
        GenerateRideEdit.call(user: user, ride: ride) unless ride.edits.any?
      end
    end
  end
end
