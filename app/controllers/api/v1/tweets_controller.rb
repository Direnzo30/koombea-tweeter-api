class Api::V1::TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    response, status_code = tweet_service.index_by_logged_user(params.permit(*page_params))
    centralize_response(response, status_code, TweetsListSerializer)
  end

  def by_user
    response, status_code = tweet_service.list_tweets_by_user(search_params)
    centralize_response(response, status_code, TweetsListSerializer)
  end

  def create
    response, status_code = tweet_service.generate_tweet(create_params)
    centralize_response(response, status_code)
  end

  private

  def create_params
    params.permit(:content)
  end

  def search_params
    params.permit(:user_id, *page_params)
  end

  def tweet_service
    @tweet_service ||= TweetService.new(curr_user)
  end

end