class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :photos
  has_many :rides
  has_many :locations, :through => :rides

  accepts_nested_attributes_for :photos

  def feed_photos
    _photos = []
    locations.each do |location|
      Camera.find_candidates(location, 
                         location.timestamp.ago(Photo::TIME_MARGIN_OF_ERROR), 
                         location.timestamp.since(Photo::TIME_MARGIN_OF_ERROR)
                        ).each do |camera|
        if camera.strength(location.timestamp, self) > Camera::MIN_STRENGTH
          _photos += camera.photos.at(location.timestamp)
        end
      end
    end
    _photos
  end

  def location_at(datetime)
    locations.during(datetime.ago(2), datetime.since(2)).first
  end

end
