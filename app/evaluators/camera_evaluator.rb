class CameraEvaluator < Evaluator
  attribute :camera, Camera

  def coords_at(timestamp)
    camera.time_series_data.coords_at(timestamp)
  end

  def coords
    coords_at(now)
  end

  # The proximity method
  def strength(user_evaluator)
    kms = distance(user_evaluator)
    # puts "Camera#strength: kms #{kms} bell: #{bell}"
    bell = if kms.nil? || kms > camera.range_m / 1000.0
             0
           else
             Camera.bell(kms / (camera.range_m / 1000.0))
           end
    bell
  end

  def distance(user_evaluator)
    u_coords = user_evaluator.coords
    c_coords = coords
    return nil unless u_coords && c_coords
    Geocoder::Calculations.distance_between(u_coords, c_coords, units: :km)
  end
end
