module Edit
  class Frame
    DEFAULT_SIZE = 1.second

    include Virtus.model

    attribute :start_at
    attribute :end_at

    def self.new_from_activity(activity)
      Edit::Frame.new(start_at: activity.start_at,
                      end_at: activity.start_at + DEFAULT_SIZE)
    end

    def ==(other)
      return false unless other.is_a? Edit::Frame
      other.start_at == start_at && other.end_at == end_at
    end
  end
end
