class LocationSample < ActiveRecord::Base
  belongs_to :ride

  def self.closest_to(timestamp)
    before = LocationSample.where('timestamp <= ?', timestamp).order('timestamp DESC').limit(1).first
    after = LocationSample.where('timestamp >= ?', timestamp).order('timestamp ASC').limit(1).first
    if before && after
      (before.timestamp - timestamp).abs < (after.timestamp - timestamp).abs ? before : after
    else
      before || after
    end
  end

  reverse_geocoded_by :latitude, :longitude
end
