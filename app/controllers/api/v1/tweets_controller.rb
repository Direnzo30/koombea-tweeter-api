class Api::V1::TweetsController < ApplicationController
  before_action :authenticate_user!

  def create
    response, status_code = Tweet.generate_tweet(curr_user, create_params)
    centralize_response(response, status_code)
  end

  private

  def create_params
    params.permit(:content)
  end

end