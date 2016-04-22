class ActivitiesController < ApplicationController
  load_and_authorize_resource
  include SetActivity
  before_action :set_activity, only: [:show, :recut]

  def index
    @activities = Activity.all
  end

  def show
  end

  def recut
    RoughCutEditor.call(activity: @activity)
    redirect_to @activity
  end
end
