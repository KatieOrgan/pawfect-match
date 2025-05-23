class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_user, unless: :devise_controller?

  protected

  # Permit additional fields (like username, first_name, last_name) for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :location])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :location])
  end

  def set_user
    @user = current_user
  end
end
