class Api::V1::TokensController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]
  def create
    @user = User.find_by_email(user_params[:email])

    if @user&.authenticate(user_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      response.set_header('Authorization', "Bearer #{token}")
      render json: {
        token: token ,
        data: @user
      }
    else
      render json:{
        error: "Invalid email or password"
      },
      status: :unauthorized
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
