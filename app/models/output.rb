class Output < ActiveRecord::Base
  enum media_type: {
    video: 0,
    audio: 1
  }
  belongs_to :job
end
