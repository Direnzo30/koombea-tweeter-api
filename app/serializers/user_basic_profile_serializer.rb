class UserBasicProfileSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :username,
             :total_followed, :total_followers,
             :followed
end