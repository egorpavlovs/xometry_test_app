class SessionsController < BaseController
  skip_before_action :authenticate

  def create
    @auth = AuthService.call(action: :get_token, credentials: user_params)

    if @auth.success?
      render json: { token: @auth.value }, status: :ok
    else
      render json: { message: @auth.error }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password).to_h
  end
end
