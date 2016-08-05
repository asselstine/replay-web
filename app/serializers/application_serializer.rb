class ApplicationSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id
end
