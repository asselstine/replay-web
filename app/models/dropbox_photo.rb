class DropboxPhoto < ActiveRecord::Base
  belongs_to :dropbox_event
  validates_presence_of :dropbox_event
  mount_uploader :photo, PhotoUploader

  reverse_geocoded_by :latitude, :longitude
end
