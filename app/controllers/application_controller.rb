class ApplicationController < ActionController::API
  include Authenticable
  before_action :authenticate_user

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      decoded = JsonWebToken.decode(token)
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: {
        error: "Not Authorized"
      },
      status: :unauthorized
    end
  end
end
