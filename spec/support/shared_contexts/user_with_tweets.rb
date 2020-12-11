def create_user_with_tweets(top_limit)
  user_with_tweets = create(:user)
  tweets = []
  (0..top_limit).each do |i|
    tweets << create(:tweet, user: user_with_tweets).id
  end
  [user_with_tweets, tweets]
end

RSpec.shared_context "user_with_tweets" do
  before(:example) do
    @user_with_tweets, @tweets = create_user_with_tweets(rand(1..9))
  end
end

RSpec.shared_context "user_with_tweets_and_following" do
  before(:example) do
    @user_with_tweets, @tweets = create_user_with_tweets(1)
    (0..rand(1..3)).each do 
      u, t = create_user_with_tweets(1)
      Follow.create!({ user_id: @user_with_tweets.id, followed_id: u.id })
      @tweets.concat(t)
    end
  end
end