class TweetsListSerializer < ActiveModel::Serializer
  attributes :id, :content, :first_name, :last_name, :username, :created_at
end