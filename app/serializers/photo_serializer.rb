class PhotoSerializer < BaseSerializer
  attributes :timestamp, :filename, :thumb_url, :small_url

  def thumb_url
    object.image.thumb.url
  end

  def small_url
    object.image.small.url
  end
end
