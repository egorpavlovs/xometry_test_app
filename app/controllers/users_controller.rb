class UsersController < BaseController
  skip_before_action :verify_authenticity_token, only: %i[update]
  skip_before_action :authenticate

  def create
    @auth = AuthService.call(action: :create_user, credentials: {
      username: user_params[:username],
      email: user_params[:email],
      password: user_params[:password]
    })

    if @auth.success?
      UserVerificationJob.perform_async({ email: @auth.value.email, username: @auth.value.username }.to_json)

      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { message: @auth.error }, status: :unprocessable_entity
    end
  end

  def update
    @auth = AuthService.call(action: :verification, credentials: { email: user_params[:email] })

    if @auth.success?
      render json: { message: 'User verified successfully' }, status: :ok
    else
      # TODO: Add html with confirmation of verification
      render json: { message: @auth.error }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password).to_h
  end
end
