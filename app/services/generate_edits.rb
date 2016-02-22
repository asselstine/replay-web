class GenerateEdits
  include Service
  include Virtus.model

  attribute :user

  def call
    user.rides.find_each do |ride|
      GenerateRideEdit.call(user: user, ride: ride) unless ride.edits.any?
    end
  end
end
