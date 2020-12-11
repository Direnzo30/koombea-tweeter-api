RSpec.shared_context "user_with_tweets" do
  before(:example) do
    @user_with_tweets = create(:user)
    @tweets = []
    top_limit = rand(5..15)
    (0..top_limit).each do |i|
      @tweets << create(:tweet, user: @user_with_tweets).id
    end
  end
end