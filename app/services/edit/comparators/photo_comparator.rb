module Edit
  class PhotoComparator < Edit::Comparator
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
      @photos = setup.photos_during(frame.start_at, frame.end_at)
      @photos.any?
    end
  end
end
