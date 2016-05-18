class BaseSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :errors, :error_messages, :created_at

  def error_messages
    object.errors.full_messages
  end
end
