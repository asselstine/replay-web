# rubocop:disable Style/ClassAndModuleChildren
class Edit::MultiVideoProcessor < Edit::Processor

  def process(frame)
    ActiveRecord::Base.transaction do
      # find all activities in frame
    end
  end

  def continuing_drafts
    @continuing_drafts ||= []
  end

  def complete_drafts
    @complete_drafts ||= []
  end
end
