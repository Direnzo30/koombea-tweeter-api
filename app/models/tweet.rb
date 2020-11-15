# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  content    :string(280)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_tweets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tweet < ApplicationRecord

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 280 }

  include EndpointsHandler

  def self.generate_tweet(user, params)
    flat_endpoint do
      tweet_params = { user_id: user.id }.merge(params)
      tweet = self.new(tweet_params)
      raise ActiveRecord::RecordInvalid.new(tweet) unless tweet.valid?
      tweet.save!
      { content: { tweet_id: tweet.id }}
    end
  end


end
