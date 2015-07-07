class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :photos
  has_many :rides
  has_many :location_samples, :through => :rides

  def feed_photos
    location_samples.map do |ls|
      photos = Photo.near([ls.latitude, ls.longitude], 8.0/1000.0, :units => :km)
      photos
    end.flatten.uniq
  end

end
