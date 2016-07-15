class Edit::PhotoProcessor < Edit::Processor
  protected

  def process(comparator)
    comparator.photos.each do |photo|
      @drafts << PhotoDraft.new(photo: photo,
                                setup: comparator.setup,
                                activity: comparator.activity,
                                name: photo.filename)
    end
    @frame.end_at
  end
end
