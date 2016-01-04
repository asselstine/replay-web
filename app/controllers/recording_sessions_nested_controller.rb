class RecordingSessionsNestedController < LoggedInController
  before_action :find_recording_session

  protected 

  def find_recording_session
    @recording_session = RecordingSession.find(params[:recording_session_id])
  end
end
