class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:edit, :update, :destroy]

  def index
    # Display all bookings belonging to the current user
    @bookings = current_user.bookings.order(created_at: :desc)
  end

  def new
    # Only used if we want to show the pet info on the new page
    @pet = Pet.find_by(id: params[:pet_id])
    if @pet.nil?
      redirect_to pets_path, alert: "Pet not found."
      return
    end

    @booking = Booking.new
  end

  def create
    @pet = Pet.find_by(id: booking_params[:pet_id])
    unless @pet
      redirect_to pets_path, alert: "Pet not found."
      return
    end

    @booking = current_user.bookings.build(booking_params.except(:pet_id))
    @booking.pet = @pet

    if @booking.save
      redirect_to bookings_path, notice: "Booking was successfully created."
    else
      Rails.logger.debug("Booking Save Errors: #{@booking.errors.full_messages}")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @booking is set by set_booking
  end

  def update
    if @booking.update(booking_params.except(:pet_id))
      redirect_to bookings_path, notice: "Booking was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = current_user.bookings.find(params[:id])
    if @booking.destroy
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    else
      redirect_to bookings_path, alert: 'Failed to cancel the booking.'
    end
  end

  private

  def booking_params
    # Include pet_id so we can handle it explicitly in create
    params.require(:booking).permit(:start_date, :end_date, :status, :pet_id)
  end

  def set_booking
    # Ensure the user can only edit/update/destroy their own bookings
    @booking = current_user.bookings.find_by(id: params[:id])
    if @booking.nil?
      redirect_to bookings_path, alert: "You are not authorized to access this booking."
    end
  end
end
