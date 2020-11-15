class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    response, status_code = Follow.generate_follow(curr_user, create_params)
    centralize_response(response, status_code)
  end

  private

  def create_params
    params.permit(:followed_id)
  end

end