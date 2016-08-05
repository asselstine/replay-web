class PhotoSerializer < ModelSerializer
  attributes :timestamp, :filename, :url, :thumb_url, :small_url

  def url
    object.image.url
  end

  def thumb_url
    object.image.thumb.url
  end

  def small_url
    object.image.small.url
  end
end
