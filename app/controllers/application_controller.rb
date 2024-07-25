class ApplicationController < ActionController::API
  private

  def authenticate_request
    @current_user = authorize_request
    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
    User.find(decoded["user_id"]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    nil
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })[0]
  end

  def current_user
    @current_user
  end
end
