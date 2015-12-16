module Trackable
  extend ActiveSupport::Concern
  included do
    def coords_at(datetime)
      locations.interpolate_at(datetime)
    end
  end
end
