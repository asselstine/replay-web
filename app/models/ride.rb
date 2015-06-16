class Ride < ActiveRecord::Base
  has_many :location_samples, -> { order('timestamp DESC') }
  accepts_nested_attributes_for :location_samples
end
