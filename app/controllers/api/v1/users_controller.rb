class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: []
    
    def followers
      response, status_code = User.get_followers(curr_user, following_params)
      centralize_response(response, status_code)
    end

    def followed
      response, status_code = User.get_followed(curr_user, following_params)
      centralize_response(response, status_code, FollowedUserSerializer)
    end

    private

    def following_params
      params.permit(:id)
    end
  end
  
  