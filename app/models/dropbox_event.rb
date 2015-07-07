class DropboxEvent < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :path
  validates_presence_of :path, :user
  has_many :dropbox_photos
  before_create :synchronize

  def synchronize
    DropboxSync.new.synchronize(self)
  end

end
