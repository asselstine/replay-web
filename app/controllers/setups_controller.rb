class SetupsController < LoggedInController
  before_action :find_setup, only: [:show, :edit, :update, :destroy]

  def new
    @setup = Setup.new
  end

  def index
    @setups = current_user.setups.order(updated_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @setup.update(setup_params)
      ajax_notice I18n.t('flash.activerecord.update.success')
      render json: @setup, status: :ok
    else
      render json: @setup, status: :unprocessable_entity
    end
  end

  def create
    @setup = Setup.create(setup_params)
    if @setup.persisted?
      ajax_notice I18n.t('flash.activerecord.create.success')
      render json: @setup, status: :ok
    else
      render json: @setup, status: :unprocessable_entity
    end
  end

  def destroy
    if @setup.destroy
      redirect_to setups_path, notice: 'Destroyed Setup'
    else
      redirect_to setup_path(@setup), alert: 'Could not destroy setup'
    end
  end

  protected

  def setup_params
    params
      .require(:setup)
      .permit(:name, :range_m, :latitude, :longitude, :location)
      .merge(user: current_user)
  end

  def find_setup
    @setup = Setup.find(params[:id])
  end
end
