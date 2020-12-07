class Api::V1::SessionsController < ApplicationController
before_action :authenticate_user!, only: [:signout]

  def signup
    response, status_code = clean_session_service.signup(signup_params)
    centralize_response(response, status_code)
  end

  def signin
    response, status_code = clean_session_service.signin(signin_params)
    centralize_response(response, status_code, UserAuthSerializer)
  end

  def signout
    response, status_code = session_service.signout
    centralize_response(response, status_code)
  end

  private

  def signup_params
    params.permit(:first_name, :last_name, :username, :email, :password)
  end

  def signin_params
    params.permit(:username, :password)
  end

  def clean_session_service
    @clean_session_service ||= SessionService.new
  end

  def session_service
    @session_service ||= SessionService.new(curr_user)
  end
  
end

