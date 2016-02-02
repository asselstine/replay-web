class RecordingSessionsController < LoggedInController
  def index
    @recording_sessions = current_user.recording_sessions
  end

  def show
    @recording_session = RecordingSession.find(params[:id])
  end

  def new
    @recording_session = RecordingSession.new
  end

  def create
    @recording_session = RecordingSession.create(create_params)
    respond_to do |format|
      if @recording_session.persisted?
        format.html do
          redirect_to @recording_session
        end
      else
        format.html do
          render 'new'
        end
      end
    end
  end

  protected

  def create_params
    params.require(:recording_session)
          .permit(:name, :start_at)
          .merge(user: current_user)
  end
end
