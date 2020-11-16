# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  content    :string(280)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
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

  # Retrieves all the feeds associated to current user and his dependencies
  def self.index_by_logged_user(user, params)
    flat_endpoint do
      tweets = Tweet.joins("INNER JOIN users U ON tweets.user_id = u.id")
                    .where("U.id = :id OR U.id IN (SELECT followed_id FROM follows F WHERE F.user_id = :id)", { id: user.id })
      metadata = get_pagination_metadata(params, tweets)
      tweets = tweets.select("tweets.*, U.username, U.first_name, U.last_name")
                     .order("tweets.created_at DESC")
                     .paginate(metadata)
      { content: tweets, metadata: metadata }
      
    end
  end

  # Retrieves list for specific user - do not confuse with feed
  def self.list_tweets_by_user(user, params)
    flat_endpoint do
      requested_user = User.find(params[:user_id])
      tweets = Tweet.joins("INNER JOIN users U ON tweets.user_id = u.id")
                    .where("U.id = ?", requested_user.id)
      metadata = get_pagination_metadata(params, tweets)
      tweets = tweets.select("tweets.*, U.username, U.first_name, U.last_name")
                     .order("tweets.created_at DESC")
                     .paginate(metadata)
      { content: tweets, metadata: metadata.merge(username: requested_user.username) }
    end
  end


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
