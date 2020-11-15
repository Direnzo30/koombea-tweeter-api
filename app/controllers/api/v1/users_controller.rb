class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: []
    
  end
  
  