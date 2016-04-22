module SetActivity
  extend ActiveSupport::Concern

  included do
    def set_activity
      @activity = Activity.find(params.require(:id))
    end
  end
end
