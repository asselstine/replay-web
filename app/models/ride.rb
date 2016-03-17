class Ride < ActiveRecord::Base
  belongs_to :user
  has_many :edits
  has_many :locations, as: :trackable
  accepts_nested_attributes_for :locations

  def to_s
    <<-STRING
      Ride(#{id}) {
                    user: #{user.id},
                    strava_activity_id: #{strava_activity_id},
                    strava_name: #{strava_name},
                    strava_start_at: #{strava_start_at}
                  }
    STRING
  end

  def start_at
    locations.minimum(:timestamp)
  end

  def end_at
    locations.maximum(:timestamp)
  end

  def interpolated_coords
    coords = []
    frame = Frame.new(start_at: object.start_at, end_at: object.end_at)
    re = RideEvaluator.new(ride: self, frame: frame)
    loop do
      coords << re.coords
      break unless frame.next!
    end
  end
end
