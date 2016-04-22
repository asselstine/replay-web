class SetupsController < LoggedInController
  def index
    @setups = current_user.setups
  end

  def show
  end
end
