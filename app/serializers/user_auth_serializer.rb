class UserAuthSerializer < ActiveModel::Serializer
  attributes :id, :email, :authorization_token, :created_at, :updated_at
end