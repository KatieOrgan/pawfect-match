class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update_user_details, :update_profile_picture]

  def show
    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @bookings = @user.bookings.order(start_date: :desc) || []
    end
  end

  def update_user_details
    @user = User.find(params[:id])
    @bookings = @user.bookings.order(start_date: :desc)
  
    if @user.update_without_password(user_details_params)
      redirect_to @user, notice: "Details updated successfully."
    else
      flash.now[:alert] = "Update failed: #{@user.errors.full_messages.to_sentence}"
      render :show, status: :unprocessable_entity
    end
  end 

  def update_profile_picture
    if params[:profile_picture].present?
      @user.profile_picture.attach(params[:profile_picture])
      if @user.save(validate: false)
        redirect_to @user, notice: "Profile picture updated successfully."
      else
        redirect_to @user, alert: "Failed to save profile picture."
      end
    else
      redirect_to @user, alert: "Please select an image to upload."
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_details_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :bio, :is_owner)
  end
  
  # This removes password from validations if not provided
  def skip_password_validation
    { password: nil, password_confirmation: nil }
  end
  
end
