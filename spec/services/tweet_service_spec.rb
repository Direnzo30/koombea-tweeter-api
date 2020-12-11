require 'rails_helper'

RSpec.describe TweetService do
  subject { described_class.new(create(:user)) }

  describe "::generate_tweet" do
    let(:result) { subject.generate_tweet(*parameters) }

    context "when content is not present" do
      let(:parameters) { [content: nil] }
      it_behaves_like "an unprocessable response"
    end

    context "when content is valid" do
      let(:parameters) { [{content: Faker::Lorem.characters(number: rand(1..280))}] }

      it_behaves_like "a valid response"

      it "creates the tweet" do
        expect(result.first[:content][:tweet_id]).not_to be_nil
      end
    end
  end

  describe "::list_tweets_by_user" do
    let(:result) { subject.list_tweets_by_user(*parameters) }

    context "when user doesn't exist" do
      let(:parameters) { [{user_id: 0, page: 1, per_page: 10}] }
      it_behaves_like "an unprocessable response"
    end

    context "when user exists" do
      context "when user doesn't have tweets" do
        let(:parameters) { [user_id: subject.current_user.id, page: 1, per_page: 10] }

        it_behaves_like "a valid response"

        it "retrieves zero tweets" do
          response = result.first
          expect(response[:content].size).to be_zero
          expect(response[:metadata][:username]).to eq(subject.current_user.username)
        end
      end

      context "when user have tweets" do
        include_context "user_with_tweets"
        let(:parameters) { [{user_id: @user_with_tweets.id, page:1, per_page: 10}] }

        it_behaves_like "a valid response"

        it "retrieves the user's tweets paginated" do
          response = result.first
          expect(response[:content].map(&:id).sort).to eq(@tweets)
          expect(response[:metadata][:username]).to eq(@user_with_tweets.username)
        end
      end
    end
  end

  describe "::index_by_logged_user" do
    let(:result) { described_class.new(@user_with_tweets).index_by_logged_user(*parameters) }

    context "when the user have tweets and follow other users" do
      include_context "user_with_tweets_and_following"
      let(:parameters) { [{user_id: @user_with_tweets.id, page:1, per_page: 10}] }

      it_behaves_like "a valid response"

      it "retrives the tweets of the user and his followings" do
        response = result.first
          expect(response[:content].map(&:id).sort).to eq(@tweets.sort)
      end
    end
  end
end