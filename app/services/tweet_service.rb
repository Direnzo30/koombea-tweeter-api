class TweetService < BaseService

  def initialize(current_user = nil)
    super(current_user)
  end

  # Retrieves all the feeds associated to current user and his dependencies
  def index_by_logged_user(params)
    flat_endpoint do
      tweets = Tweet.joins("INNER JOIN users U ON tweets.user_id = u.id")
                    .where("U.id = :id OR U.id IN (SELECT followed_id FROM follows F WHERE F.user_id = :id)", { id: @current_user.id })
      metadata = Pagination::metadata(params, tweets)
      tweets = tweets.select("tweets.*, U.username, U.first_name, U.last_name")
                     .order("tweets.created_at DESC")
                     .paginate(metadata)
      { content: tweets, metadata: metadata }
    end
  end

  # Retrieves list for specific user - do not confuse with feed
  def list_tweets_by_user(params)
    flat_endpoint do
      requested_user = User.find(params[:user_id])
      tweets = Tweet.joins("INNER JOIN users U ON tweets.user_id = u.id")
                    .where("U.id = ?", requested_user.id)
      metadata = Pagination::metadata(params, tweets)
      tweets = tweets.select("tweets.*, U.username, U.first_name, U.last_name")
                     .order("tweets.created_at DESC")
                     .paginate(metadata)
      { content: tweets, metadata: metadata.merge(username: requested_user.username) }
    end
  end


  def generate_tweet(params)
    flat_endpoint do
      tweet_params = { user_id: @current_user.id }.merge(params)
      tweet = self.new(tweet_params)
      raise ActiveRecord::RecordInvalid.new(tweet) unless tweet.valid?
      tweet.save!
      { content: { tweet_id: tweet.id } }
    end
  end

end