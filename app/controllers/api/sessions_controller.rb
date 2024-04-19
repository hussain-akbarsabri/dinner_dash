class Api::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  skip_before_action :verify_authenticity_token
  
  private
  
  def respond_with(current_user, _opts = {})
    render json: { message: "Logged in successfully!", status: 200, body: current_user }, status: :ok
  end
  
  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: { message: "Logged out successfully!", status: 200 }, status: :ok
    else
      render json: { message: "Couldn't find an active session.", status: 401 }, status: :unauthorized
    end
  end
end
