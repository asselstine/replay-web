class ScrubImageSerializer < ActiveModel::Serializer
  attributes :url, :index

  def url
    object.image.url
  end
end
