class DraftSerializer < BaseSerializer
  attributes :type, :start_at, :end_at
  has_one :setup
  has_one :video
  has_one :activity
end
