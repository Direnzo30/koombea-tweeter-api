class Api::V1::TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    response, status_code = Tweet.index_by_logged_user(curr_user, params.permit(*page_params))
    centralize_response(response, status_code, TweetsListSerializer)
  end

  def by_user
    response, status_code = Tweet.list_tweets_by_user(curr_user, search_params)
    centralize_response(response, status_code, TweetsListSerializer)
  end

  def create
    response, status_code = Tweet.generate_tweet(curr_user, create_params)
    centralize_response(response, status_code)
  end

  private

  def create_params
    params.permit(:content)
  end

  def search_params
    params.permit(:user_id, *page_params)
  end

end