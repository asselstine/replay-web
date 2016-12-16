class DraftSerializer < ModelSerializer
  attributes :colour,
             :end_at_f,
             :end_at,
             :latitudes,
             :longitudes,
             :name,
             :start_at_f,
             :start_at,
             :timestamps_f,
             :type

  has_one :setup

  def start_at_f
    object.start_at.to_f
  end

  def end_at_f
    object.end_at.to_f
  end

  def timestamps_f
    object.timestamps.map(&:to_f)
  end
end
