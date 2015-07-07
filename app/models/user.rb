class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :rides
  has_many :location_samples, :through => :rides

  def photos
    location_samples.map do |ls|
      photos = DropboxPhoto.near([ls.latitude, ls.longitude], 1, :units => :km)
      photos
    end.flatten.uniq
  end

end
