class Api::V1::UsersController < ApplicationController

  # Get /users/1
  def show
    @user = User.find(params[:id])
    render json: @user
  end
end
