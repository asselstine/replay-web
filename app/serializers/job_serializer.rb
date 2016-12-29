class JobSerializer < ApplicationSerializer
  attributes :id, :status, :message

  has_one :video
  has_one :upload
end
