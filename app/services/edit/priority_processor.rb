class Edit::PriorityProcessor < Edit::Processor
  attribute :selector

  protected

  def process(frame)
    comparator = selector.find_best(frame)
    if comparator
      process_comparator(frame, comparator)
    else
      frame.end_at
    end
  end

  def process_comparator(_, _)
    raise 'processor_comparator(frame, comparator): missing implementation'
  end
end
