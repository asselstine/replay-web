class CameraEvaluator < Evaluator
  attribute :camera, Camera

  def coords_at(timestamp)
    Location.static_coords_at(timestamp, camera_locations)
  end

  def coords
    coords_at(context.cut_start_at)
  end

  def strength(user_evaluator)
    # The proximity method
    u_coords = user_evaluator.coords
    c_coords = coords
    # puts "Camera#strength: c id: #{id}: c_coords: #{c_coords}, u_coords: #{u_coords}, start_at: #{start_at.to_f}"
    return 0 unless u_coords && c_coords
    kms = Geocoder::Calculations.distance_between(u_coords, c_coords, units: :km)
    bell = Camera.bell(kms / (camera.range_m / 1000.0))
    # puts "Camera#strength: kms #{kms} bell: #{bell}"
    bell
  end

  protected

  def camera_locations
    @_camera_locations ||= camera.locations.during(context.start_at, context.end_at)
  end
end
