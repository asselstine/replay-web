class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :locations, as: :trackable
  accepts_nested_attributes_for :locations
end
