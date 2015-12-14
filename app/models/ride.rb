class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :locations, -> {
    order('timestamp DESC')
  }, as: :trackable
  accepts_nested_attributes_for :locations
end
