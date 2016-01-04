class CamerasNestedController < RecordingSessionsNestedController
  before_action :find_camera

  protected

  def find_camera
    @camera = Camera.find(params[:camera_id])
  end
end
