class BaseController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate

  attr_reader :current_user

  private

  def authenticate
    authenticate_user_with_token || handle_bad_authentication
  end

  def authenticate_user_with_token
    ApiToken.find_by_token(token)
  end

  def handle_bad_authentication
    render json: { message: "Bad credentials" }, status: :unauthorized
  end

  def token
    request.headers["Authorization"]
  end
end
