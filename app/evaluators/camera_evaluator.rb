class CameraEvaluator < Evaluator
  attribute :camera, Camera

  def coords_at(timestamp)
    camera_locations.before(timestamp).first
  end

  def coords
    coords_at(now)
  end

  # The proximity method
  def strength(user_evaluator)
    kms = distance(user_evaluator)
    # puts "Camera#strength: kms #{kms} bell: #{bell}"
    bell = if kms > camera.range_m / 1000.0
             0
           else
             Camera.bell(kms / (camera.range_m / 1000.0))
           end
    bell
  end

  def distance(user_evaluator)
    u_coords = user_evaluator.coords
    c_coords = coords
    return 0 unless u_coords && c_coords
    Geocoder::Calculations.distance_between(u_coords, c_coords, units: :km)
  end

  protected

  def camera_locations
    @_camera_locations ||= camera.locations.before(frame.end_at)
  end
end
