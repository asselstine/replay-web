class DraftSerializer < BaseSerializer
  attributes :type, :start_at, :end_at, :start_at_f, :end_at_f
  has_one :setup
  has_one :video
  has_one :activity

  def start_at_f
    start_at.to_f
  end

  def end_at_f
    end_at_f
  end
end
