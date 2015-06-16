class DropboxEvent < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :path

  def synchronize

    #pull new delta from dropbox_browser
    #create photos as needed

  end

end
