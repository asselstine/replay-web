class ScrubImageSerializer < ApplicationSerializer
  attributes :url, :index

  def url
    object.image.url
  end
end
