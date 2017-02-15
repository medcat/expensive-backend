class UserSerializer < ActiveModel::Serializer
  type :user
  attributes :id, :email

  link(:self) { api_user_path(object.id) }
end
