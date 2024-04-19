class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: { message: "Signed up successfully!", status: 200, body: current_user }, status: :ok
    else
      render json: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}", status: 401 }, status: :unprocessable_entity
    end
  end
end