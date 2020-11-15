class UserAuthSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :username,
             :email, :authorization_token, :created_at,
             :updated_at
end