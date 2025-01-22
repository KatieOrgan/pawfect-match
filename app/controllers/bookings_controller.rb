class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:edit, :update, :destroy]
  before_action :set_pet, only: [:new, :create]

  def index
    @bookings = Booking.all
  end

  def show
    @booking = Booking.find(params[:id])
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
    redirect_to bookings_url, notice: 'Booking was successfully cancelled.'
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status, :user_id, :pet_id)
  end

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end
