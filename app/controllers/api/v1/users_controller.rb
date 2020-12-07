class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: []
    
    def followers
      response, status_code = user_service.following_the_user(following_params)
      centralize_response(response, status_code, FollowListUserSerializer)
    end

    def followed
      response, status_code = user_service.followed_by_the_user(following_params)
      centralize_response(response, status_code, FollowListUserSerializer)
    end

    def show
      response, status_code = user_service.basic_profile(params.permit(:id))
      centralize_response(response, status_code, UserBasicProfileSerializer)
    end

    private

    def following_params
      params.permit(:id, *page_params)
    end

    def user_service
      @user_service ||= UserService.new(curr_user)
    end
  end
  
  