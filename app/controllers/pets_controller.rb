class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  
    if params[:query].present?
      @pets = @pets.search_by_breed_and_size_and_description_and_pet_name_and_available(params[:query])
    end
  
    if params[:breed].present? && params[:breed] != "All Breeds"
      @pets = @pets.where(breed: params[:breed])
    end
  
    if params[:size].present? && params[:size] != "All Sizes"
      @pets = @pets.where(size: params[:size])
    end
  
    if params[:location].present?
      @pets = @pets.near(params[:location], 50) # 50 miles radius
    end
    
    if params[:location].present?
      distance = params[:distance].presence || 50
      @pets = Pet.near(params[:location], distance)
    end
    
    if params[:available_from].present?
      @pets = @pets.where("available_from >= ?", params[:available_from])
    end
  
    if params[:available_until].present?
      @pets = @pets.where("available_until <= ?", params[:available_until])
    end
  
    if params[:available].present?
      available = ActiveModel::Type::Boolean.new.cast(params[:available])
      @pets = @pets.where(booked: !available)
    end
  end
  
  def show
    @pet = Pet.find(params[:id])
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user
    if @pet.save
      redirect_to @pet, notice: 'Pet was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update(pet_params)
      redirect_to @pet, notice: 'Pet was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet = Pet.find(params[:id])

    # Allow only the owner to delete the pet
    if @pet.user == current_user
      @pet.destroy
      flash[:notice] = 'Pet was successfully removed.'
    else
      flash[:alert] = 'You are not authorized to delete this pet.'
    end

    redirect_to user_path(current_user)
  end

  private

  def authorize_owner
    unless current_user.is_owner
      redirect_to pets_path, alert: 'Only pet owners can add pets!'
    end
  end

  def pet_params
    params.require(:pet).permit(:pet_name,
                                :breed,
                                :age,
                                :size,
                                :description,
                                :location,
                                :available_from,
                                :available_until,
                                :highlights,
                                :booked,
                                :pet_photo)
  end
  end
