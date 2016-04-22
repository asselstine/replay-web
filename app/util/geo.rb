module Geo
  def self.distance_strength(coords1, coords2, range_m)
    return 0 unless coords1 && coords2
    kms = Geocoder::Calculations.distance_between(coords1, coords2, units: :km)
    # puts "Camera#strength: kms #{kms} bell: #{bell}"
    bell = if kms.nil? || kms > range_m / 1000.0
             0
           else
             bell(kms / (range_m / 1000.0))
           end
    bell
  end

  # Transfer Function:
  # Bell curve with a tweak to support range
  def self.bell(x)
    Math::E**-[x, 100.0].min**2
  end
end
