class Edit < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  has_many :cuts, inverse_of: :edit, dependent: :destroy
  has_many :videos, through: :cuts
  has_many :cameras, through: :videos
  has_many :final_cuts, dependent: :destroy
  accepts_nested_attributes_for :cuts

  delegate :start_at, to: :ride
  delegate :end_at, to: :ride
end
