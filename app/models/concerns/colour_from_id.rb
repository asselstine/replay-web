module ColourFromId
  extend ActiveSupport::Concern

  def colour
    srand(id)
    (rand * 16_777_216).floor.to_s(16).rjust(6, '0')
  end
end
