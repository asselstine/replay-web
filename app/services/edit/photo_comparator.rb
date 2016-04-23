# rubocop:disable Style/ClassAndModuleChildren
class Edit::PhotoComparator < Edit::Comparator
  attribute :photos, Array[Photo]

  def compute_strength(frame)
    @strength = if photos_during?(frame)
                  distance_strength(frame)
                else
                  0
                end
  end

  protected

  def photos_during?(frame)
    @photos = setup.photos_during(frame)
    @photos.any?
  end
end
