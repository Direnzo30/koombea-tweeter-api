class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: []
    
    def followers
      response, status_code = User.get_following_the_user(curr_user, following_params)
      centralize_response(response, status_code, FollowListUserSerializer)
    end

    def followed
      response, status_code = User.get_followed_by_the_user(curr_user, following_params)
      centralize_response(response, status_code, FollowListUserSerializer)
    end

    def show
      response, status_code = User.basic_profile(curr_user, params.permit(:id))
      centralize_response(response, status_code, UserBasicProfileSerializer)
    end

    private

    def following_params
      params.permit(:id, *page_params)
    end
  end
  
  