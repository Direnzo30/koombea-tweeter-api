class FollowListUserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :username, :followed, :created_at
end