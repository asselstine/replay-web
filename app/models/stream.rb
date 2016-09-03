class Stream < ActiveRecord::Base
  belongs_to :playlist

  validates :playlist, :ts_key, :playlist_key, presence: true
end
