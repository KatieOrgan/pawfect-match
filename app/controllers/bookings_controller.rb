class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_pet, only: [:new, :create]

  def index
    @bookings = current_user.bookings.includes(:pet)
  end

  def show
    @booking
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to bookings_path, notice: 'Booking was successfully deleted.'
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status, :user_id, :pet_id)
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])
    unless @booking&.user == current_user
      redirect_to bookings_path, alert: 'You are not authorized to access this booking or it does not exist.'
    end
  end

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end
