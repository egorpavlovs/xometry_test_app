class AuthService
  # TODO: move to separate services
  REGISTRY = {
    create_user: :create_user,
    verification: :verification,
    get_token: :get_token
  }

  def self.call(action:, credentials: {})
    new(action, credentials).call
  end

  def initialize(action, credentials)
    @action = action
    @email = credentials[:email]
    @password = credentials[:password]
    @username = credentials[:username]
  end

  def call
    current_action = REGISTRY[action.to_sym]
    return failure('Invalid action') if current_action.nil?

    send(current_action)
  end

  private

  attr_reader :action, :email, :password, :username

  def create_user
    new_user = User.create(username: username, email: email, encrypted_password: encrypted_password)

    if new_user.valid?
      success(new_user)
    else
      failure(new_user.errors.full_messages.to_sentence)
    end
    
  rescue ActiveRecord::RecordNotUnique
    failure("Username or email already taken")
  end

  def verification
    return failure('Invalid credentials') if user_by_email.nil?
    return failure('User already verified') if user_by_email.verified?

    # TODO: add check with verification token

    user_by_email.update(verified: true)
    success('User verified successfully')
  end

  def get_token
    return failure('Invalid credentials') if user.nil?

    if user.verified?
      success(token(user))
    else
      failure('User not verified')
    end
  end

  def user
    @user ||= User.find_by(email: email, encrypted_password: encrypted_password)
  end

  def user_by_email
    @user_by_email ||= User.find_by(email: email)
  end

  def encrypted_password
    Digest::MD5.hexdigest(password)
  end

  def token(user)
    ApiToken.find_or_create_by(user: user).token
  end

  def success(data)
    Utils::Result.success(data)
  end

  def failure(error)
    Utils::Result.failure(error)
  end
end
