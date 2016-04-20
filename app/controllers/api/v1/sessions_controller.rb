module Api::V1
  class SessionsController < Api::BaseController
    skip_before_action :authenticate_user_from_token!
    before_action :ensure_params_exist

    def create
      @user = User.find_for_database_authentication email: user_params[:email]
      return invalid_login_attempt unless @user
      return invalid_login_attempt unless @user.valid_password? user_params[:password]
      render json: authenticate_payload(@user)
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end

    def ensure_params_exist
      if user_params[:email].blank? || user_params[:password].blank?
        return render_unauthorized errors: {unauthenticated: ["Incomplete Credentials"]}
      end
    end

    def authenticate_payload(user)
        return nil unless user && user.id

        {
          auth_token: AuthToken.encode({user_id: user.id}),
          user: {id: user.id, email: user.email}
        }
    end

    def invalid_login_attempt
      render_unauthorized error: {unauthenticated: ["Invalid credentials"]}
    end
  end
end
