class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      if user_signed_in?
        redirect_to root_path, alert: "User not found."
      else
        redirect_to new_user_session_path, alert: "User not found."
      end
    else
      @bookings = @user.bookings.order(start_date: :desc) || []
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @bookings = @user.bookings.order(start_date: :desc) || []

    if @user.update(user_params)
      # If update succeeds, redirect to the user's profile with a success message
      redirect_to @user, notice: 'User details updated successfully.'
    else
      # If update fails, render the `show` template with an error message
      flash.now[:alert] = "Failed to update user details."
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  def user_params
    # Remove `:profile_pic_url` if you're no longer using that column.
    # Instead, permit `:profile_picture` for Active Storage.
    params.require(:user).permit(
      :username,
      :first_name,
      :last_name,
      :email,
      :password,
      :bio,
      :is_owner,
      :profile_picture
    )
  end
end
