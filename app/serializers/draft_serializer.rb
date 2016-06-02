class DraftSerializer < BaseSerializer
  attributes :type

  has_one :setup
  has_one :activity
end
