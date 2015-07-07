class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :location_samples, -> { order('timestamp DESC') }
  accepts_nested_attributes_for :location_samples
end
