class ScrubImage < ActiveRecord::Base
  belongs_to :video
  mount_uploader :image, ScrubUploader
end
