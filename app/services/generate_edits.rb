class GenerateEdits
  include Service
  include Virtus.model

  attribute :user

  def call
    edits = []
    ActiveRecord::Base.transaction do
      user.rides.each do |ride|
        edits << GenerateRideEdit.call(user: user, ride: ride)
      end
    end
    edits.each do |edit|
      EditScheduler.call(edit: edit) if edit.persisted?
    end
  end
end
