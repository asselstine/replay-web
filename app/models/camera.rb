class Camera < ActiveRecord::Base
  attr_accessor :lat, :long
  def strength
    1
  end
end
