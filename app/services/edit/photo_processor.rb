# rubocop:disable Style/ClassAndModuleChildren
class Edit::PhotoProcessor < Edit::Processor
  protected

  def process(comparator)
    comparator.photos.each do |photo|
      DraftPhoto.create!(photo: photo,
                         activity: comparator.activity)
    end
    frame.end_at
  end
end
