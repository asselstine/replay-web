class Edit::PhotoProcessor < Edit::Processor
  protected

  def process(comparator)
    comparator.photos.each do |photo|
      @drafts << PhotoDraft.new(photo: photo,
                                setup: comparator.setup,
                                activity: comparator.activity)
    end
    @frame.end_at
  end
end
