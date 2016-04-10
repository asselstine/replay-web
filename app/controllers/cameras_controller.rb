class CamerasController < LoggedInController
  before_action :find_camera, except: [:new, :create]

  def new
    @camera = Camera.new(camera_params)
    @camera.build_time_series_data if @camera.time_series_data.blank?
  end

  def create
    @camera = Camera.create(camera_params)
    if @camera.persisted?
      redirect_to @camera, notice: I18n.t('flash.activerecord.create.success')
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    @camera.build_time_series_data if @camera.time_series_data.blank?
  end

  def update
    if @camera.update(camera_params)
      redirect_to @camera, notice: I18n.t('flash.activerecord.update.success')
    else
      render 'edit'
    end
  end

  def destroy
    if @camera.destroy
      redirect_to @recording_session,
                  notice: I18n.t('flash.activerecord.destroy.success')
    else
      redirect_to @recording_session,
                  notice: I18n.t('flash.activerecord.destroy.failure')
    end
  end

  protected

  def camera_params
    params.require(:camera)
          .permit(:name,
                  :range_m,
                  :recording_session_id,
                  time_series_data_attributes: [:id,
                                                timestamps: [],
                                                latitudes: [],
                                                longitudes: []])
  end

  def find_camera
    @camera = Camera.find(params[:id])
  end
end
