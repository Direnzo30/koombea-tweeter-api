class Api::V1::FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    response, status_code = follow_service.generate_follow(create_params)
    centralize_response(response, status_code)
  end

  private

  def create_params
    params.permit(:followed_id)
  end

  def follow_service
    @follow_service ||= FollowService.new(curr_user)
  end

end