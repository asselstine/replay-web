class Camera < ActiveRecord::Base
  MIN_STRENGTH = Geo.bell(1)

  has_many :uploads, inverse_of: :camera, dependent: :destroy
  has_many :videos, through: :uploads
  has_many :photos, dependent: :destroy
  has_many :setups
  belongs_to :user
  belongs_to :recording_session

  validates_presence_of :name
end
