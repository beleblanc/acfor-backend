module Api
  class BaseController < ActionController::API
    respond_to :json

    before_action :authenticate_user_from_token!

    protected 

    def current_user
      if token_from_request.blank?
        nil
      else
        authenticate_user_from_token!
      end
    end

    alias_method :devise_current_user, :current_user

    def user_signed_in?
      current_user.present?
    end
    alias_method :devise_user_signed_in?, :user_signed_in?

    def authenticate_user_from_token!
      userToken = claims
      if userToken and user = User.find_by(email: userToken[:email]) and user.valid_password?(userToken[:password])
        @current_user = user
      else
        render render_unauthorized
      end
    end

    def claims 
      AuthToken.decode(token_from_request)
    end

    def token_from_request
      auth_header = request.headers['Authorization'] and token = auth_header.split(' ').last
      if token.to_s.empty?
        token = request.parameters['token']
      end
      token
    end

    def render_unauthorized payload = {errors: {unauthorized: ['You are not authorized to perform this action']}}
      render json: payload.merge(response: {code: 401}, status: 401)
    end
  end
end
